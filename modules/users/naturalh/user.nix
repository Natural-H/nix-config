{
  self,
  inputs,
  ...
}: let
  username = "naturalh";
in {
  flake.nixosModules.${username} = {
    config,
    pkgs,
    ...
  }: {
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

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        hostname = config.networking.hostName;
        stateVersion = config.system.stateVersion;
        isWsl = false;
      };

      users.${username} = self.homeModules.${username};
    };
  };
}
