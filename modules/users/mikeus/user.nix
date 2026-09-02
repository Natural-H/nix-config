{
  self,
  inputs,
  ...
}: let
  username = "mikeus";
in {
  flake.nixosModules.${username} = {pkgs, ...}: {
    users.users.${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "nix-admins"
        "wheel"
      ];
      initialPassword = "password";
    };

    home-manager = {
      users.${username} = self.homeModules.${username};
    };
  };
}
