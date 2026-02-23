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
            env = [
              { name = "EULA"; value = "TRUE"; }
              { name = "TYPE"; value = "PAPER"; }
              { name = "MEMORY"; value = "4G"; }
            ];
            ports = [{ containerPort = 25565; name = "mc-port"; }];
            volumeMounts = [{ name = "data"; mountPath = "/data"; }];
          }];
          volumes = [{ name = "data"; persistentVolumeClaim.claimName = "minecraft-pvc"; }];
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
