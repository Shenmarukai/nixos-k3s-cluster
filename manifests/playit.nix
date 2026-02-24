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
            env = [{
              name = "SECRET_KEY";
              valueFrom = {
                secretKeyRef = {
                  name = "playit-secret";
                  key = "SECRET_KEY";
                };
              };
            }];
          }];
        };
      };
    };
  }
]
