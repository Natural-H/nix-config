{
  self,
  inputs,
  ...
}: let
  hostname = "nixos-wsl";
in {
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      isWsl = true;
    };

    modules = [
      self.nixosModules.nixosWslConfig
      self.nixosModules.nix-gc
      self.nixosModules.nix-linker
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.home-manager
      inputs.nixos-wsl.nixosModules.default
      {
        nixpkgs.config.allowUnfree = true;
        networking.hostName = hostname;
        system.stateVersion = "26.05";
      }
    ];
  };
}
