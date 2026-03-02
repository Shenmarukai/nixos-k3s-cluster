{ config, pkgs, ... }:
{
  sops = {
    defaultSopsFile = ../../../.secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "home/kubernetes/.config/sops/age/keys.txt";

    secrets = {
      k3s_token = {
        path = "/var/lib/k3s-token";
        owner = "root";
        mode = "0400";
      };
      playit_secret = {
        owner = "root";
        mode = "0400";
      };
    };
  };

  systemd = {
    services.k3s-secret-sync = {
      description = "Sync sops playit_secret to kubernetes";
      after = [ "sops-nix.service" "k3s.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c "${pkgs.k3s}/bin/kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml \
            create secret generic playit-secret \
            --namespace default \
            --from-literal=SECRET_KEY=$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.playit_secret.path} | ${pkgs.gnused}/bin/sed 's/[[:space:]]//g') \
            --dry-run=client -o yaml | ${pkgs.k3s}/bin/kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml apply -f -"
        '';
        RemainAfterExit = true;
      };
    };
  };
}
