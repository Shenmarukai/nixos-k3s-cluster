{ config, lib, pkgs, ... }:
{
  imports = [
    ../hardware/node-0-hardware.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    device = "/dev/sda";
  };

  networking = {
    hostName = "shane-node-0";
    networkmanager.enable = true;

    interfaces.eth0.ipv4.addresses = [{
      address = "10.0.0.2";
      prefixLength = 24;
    }];

    firewall.trustedInterfaces = [ "eth0" ];
    defaultGateway = "10.0.0.1";
    nameservers = [ "1.1.1.1" ];
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
    role = "agent";
    serverAddr = "https://10.0.0.1:6443";
    tokenFile = config.sops.secrets.k3s_token.path;
    extraFlags = "--node-ip=10.0.0.2 --flannel-iface=eth0";
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
