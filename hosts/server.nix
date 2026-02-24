{ config, lib, pkgs, ... }:
{
  imports = [
    ../hardware/server-hardware.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl."net.ipv4.ip_forward" = 1;
  };

  systemd.network.links = {
    "10-onboard-lan" = {
      matchConfig.MACAddress = "70:85:c2:6c:26:dd";
      linkConfig.Name = "eth-home";
    };
    "10-usb-adapter-0" = {
      matchConfig.MACAddress = "a0:ce:c8:5c:cb:9f";
      linkConfig.Name = "eth-direct";
    };
    "10-usb-adapter-1" = {
      matchConfig.MACAddress = "50:3e:aa:8b:4a:37";
      linkConfig.Name = "eth-ptzo";
    };
  };

  networking = {
    hostName = "shane-server";
    networkmanager.enable = true;
    useDHCP = false;

    interfaces = {
      eth-home.useDHCP = true;
      eth-direct.ipv4.addresses = [{
        address = "10.0.0.1";
        prefixLength = 24;
      }];
    };

    firewall = {
      trustedInterfaces = [ "eth-direct" ];
      allowedUDPPorts = [ 5353 ];
      allowedTCPPorts = [
        6443
        25565
      ];
    };

    nat = {
      enable = true;
      internalInterfaces = [ "eth-direct" ];
      externalInterface = "eth-home";
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcqdl2uc402XNn5UMuJIShs74HKiucbwMRpNQT90jJO shane-desktop"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  sops = {
    defaultSopsFile = ../.secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "home/kubernetes/.config/sops/age/keys.txt";

    secrets = {
      k3s_token = {
        path = "/var/lib/k3s-token";
      };
      playit_secret = {};
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    allowInterfaces = [ "eth-home" ];
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets.k3s_token.path;
    extraFlags = "--node-ip=10.0.0.1 --bind-address=0.0.0.0 --advertise-address=10.0.0.1 --flannel-iface=eth-direct --tls-san=shane-server.local --tls-san=shane-server";
    manifests = {
      playit    = { content = import ../manifests/playit.nix { inherit config lib; }; };
      minecraft = { content = import ../manifests/minecraft.nix; };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
