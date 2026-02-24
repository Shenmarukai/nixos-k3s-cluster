[
  {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata.name = "playit-agent";

    spec = {
      replicas = 1;
      selector.matchLabels.app = "playit-agent";

      template = {
        metadata.labels.app = "playit-agent";

        spec = {
          hostNetwork = true;

          containers = [{
            name = "playit-agent";
            image = "ghcr.io/playit-cloud/playit-agent:0.17";

            command = [ "sh" "-c" ];
            args = [
              "export SECRET_KEY=$(cat /run/secrets/playit_secret | tr -d '\\n\\r '); playit-agent"
            ];

            volumeMounts = [{
              name = "sops-volume";
              mountPath = "/run/secrets/playit_secret";
              readOnly = true;
            }];
          }];

          volumes = [{
            name = "sops-volume";

            hostPath = {
              path = "/run/secrets/playit_secret";
              type = "File";
            };
          }];
        };
      };
    };
  }
]
