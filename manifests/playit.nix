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
          containers = [{
            name = "playit-agent";
            image = "ghcr.io/playit-cloud/playit-agent:0.17";
            env = [{
              name = "SECRET_KEY";
              value = "/var/secrets/playit/secret_key";
            }];
            volumeMounts = [{
              name = "sops-secret";
              mountPath = "/var/secrets/playit";
              readOnly = true;
            }];
          }];
          volumes = [{
            name = "sops-secret";
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
