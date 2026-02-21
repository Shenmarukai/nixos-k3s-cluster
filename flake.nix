{
  description = "Shenmarukai's Nixos Kubernetes Node Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, inputs, ... }: {
    nixosConfigurations.shane-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/server.nix
        inputs.sops-nix.nixosModules.sops
      ];
    };
    nixosConfigurations.shane-node-0 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/node-0.nix
        inputs.sops-nix.nixosModules.sops
      ];
    };
  };
}
