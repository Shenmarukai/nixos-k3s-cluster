{ ... }:
{
  networking = {
    hostName = "shane-node-0";
    networkmanager.enable = true;

    interfaces.eth-direct.ipv4.addresses = [{
      address = "10.0.0.2";
      prefixLength = 24;
    }];

    firewall.trustedInterfaces = [ "eth-direct" ];
    defaultGateway = "10.0.0.1";
    nameservers = [ "1.1.1.1" ];
  };

  systemd.network.links = {
    "10-onboard-lan" = {
      matchConfig.MACAddress = "00:25:64:d6:d6:68";
      linkConfig.Name = "eth-direct";
    };
  };
}
