{ ... }:
{
  sops = {
    defaultSopsFile = ../../../.secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "home/kubernetes/.config/sops/age/keys.txt";

    secrets.k3s_token = {
      path = "/var/lib/k3s-token";
      owner = "root";
      mode = "0400";
    };
  };
}
