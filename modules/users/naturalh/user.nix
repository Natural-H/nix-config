{
  self,
  inputs,
  ...
}: let
  username = "naturalh";
in {
  flake.nixosModules.${username} = {pkgs, ...}: {
    users.users.${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "nix-admins"
        "dialout"
        "uucp"
        "wheel"
        "docker"
        "libvirtd"
        "kvm"
        "vboxusers"
      ];

      initialPassword = "password";
    };

    nix.settings.trusted-users = ["naturalh"];

    home-manager = {
      users.${username} = self.homeModules.${username};
    };
  };
}
