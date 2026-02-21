{ config, lib, pkgs, ... }:
{
  imports = [
    ../hardware/server-hardware.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    hostName = "shane-server";
    networkmanager.enable = true;
    useDHCP = false;

    interfaces = {
      eth0.useDHCP = true;
      eth1.ipv4.addresses = [{
        address = "10.0.0.1";
        prefixLength = 24;
      }];
    };

    firewall.trustedInterfaces = [ "eth1" ];

    nat = {
      enable = true;
      internalInterfaces = [ "eth1" ];
      externalInterface = "eth0";
    };
  };

  time.timeZone = "America/New_York";

  users.users.kubernetes = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... your_key_here"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  sops = {
    defaultSopsFile = ../.secrets/cluster-secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets.k3s_token = {
      path = "/var/lib/k3s-token";
    };
  };

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets.k3s_token.path;
    extraFlags = "--node-ip=10.0.0.1 --bind-address=10.0.0.1 --advertise-address=10.0.0.1 --flannel-iface=eth1";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
