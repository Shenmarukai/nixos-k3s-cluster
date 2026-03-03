{ pkgs, ... }:
{
  users.users.kubernetes = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcqdl2uc402XNn5UMuJIShs74HKiucbwMRpNQT90jJO shane-desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8AA72fp9pvp7RB5JGOhg4tvspcrninYBB/e+e7aCnX shane-laptop"
    ];
  };
}
