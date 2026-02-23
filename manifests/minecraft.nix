[
    {
      apiVersion = "v1";
      kind = "PersistentVolumeClaim";
      metadata.name = "minecraft-pvc";
      spec = {
        accessModes = [ "ReadWriteOnce" ];
        resources.requests.storage = "10Gi";
      };
    }
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata.name = "minecraft";
      spec = {
        replicas = 1;
        selector.matchLabels.app = "minecraft";
        template = {
          metadata.labels.app = "minecraft";
          spec.containers = [{
            name = "minecraft";
            image = "itzg/minecraft-server:latest";
            volumeMounts = [{
              name = "minecraft-storage"; # Changed for clarity
              mountPath = "/data";
            }];
          }];
          volumes = [{
            name = "minecraft-storage"; # This MUST match the name above
            persistentVolumeClaim.claimName = "minecraft-pvc";
          }];
        };
      };
    }
    {
      apiVersion = "v1";
      kind = "Service";
      metadata.name = "minecraft-lb";
      spec = {
        type = "LoadBalancer"; # K3s ServiceLB will bind this to your host's IP
        selector.app = "minecraft";
        ports = [{ port = 25565; targetPort = 25565; }];
      };
    }
]
