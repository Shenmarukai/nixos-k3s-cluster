{ ... }:
{
  imports = [
    ../hardware/node-0-hardware.nix

    ../modules/core/nix.nix
    ../modules/core/time.nix

    ../modules/users/kubernetes.nix

    ../modules/services/openssh.nix

    ../modules/packages/git.nix
    ../modules/packages/vim.nix
    ../modules/packages/wget.nix

    node-0/core/boot.nix

    node-0/network/networking.nix

    node-0/security/secrets.nix

    node-0/services/k3s.nix
  ];
}
