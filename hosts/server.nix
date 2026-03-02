{ ... }:
{
  imports = [
    ../hardware/server-hardware.nix

    ../modules/core/nix.nix
    ../modules/core/time.nix

    ../modules/users/kubernetes.nix

    ../modules/services/openssh.nix

    ../modules/packages/git.nix
    ../modules/packages/vim.nix
    ../modules/packages/wget.nix

    server/core/boot.nix

    server/network/networking.nix

    server/security/secrets.nix

    server/services/avahi.nix
    server/services/k3s.nix
  ];
}
