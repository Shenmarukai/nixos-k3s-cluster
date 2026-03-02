{ pkgs, ... }:
{
  users.users.kubernetes = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcqdl2uc402XNn5UMuJIShs74HKiucbwMRpNQT90jJO shane-desktop"
    ];
  };
}
