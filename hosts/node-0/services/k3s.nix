{ config, ... }:
{
  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://10.0.0.1:6443";
    tokenFile = config.sops.secrets.k3s_token.path;
    extraFlags = "--node-ip=10.0.0.2 --flannel-iface=eth-direct";
  };
}
