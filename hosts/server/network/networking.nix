{ ... }:
{
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
      eth-ptzo.ipv4.addresses = [{
        address = "192.168.100.100";
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
}
