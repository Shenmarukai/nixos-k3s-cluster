{ config, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets.k3s_token.path;
    extraFlags = "--node-ip=10.0.0.1 --bind-address=0.0.0.0 --advertise-address=10.0.0.1 --flannel-iface=eth-direct --tls-san=shane-server.local --tls-san=shane-server";
    manifests = {
      playit    = import ../../../manifests/playit.nix;
      minecraft = import ../../../manifests/minecraft.nix;
    };
  };
}
