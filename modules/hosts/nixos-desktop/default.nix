{
  self,
  inputs,
  ...
}: let
  hostname = "nixos-desktop";
in {
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.nixosDesktopConfig
      self.nixosModules.kdeplasma
      self.nixosModules.nix-gc
      self.nixosModules.nix-linker
      self.nixosModules.fonts
      inputs.flatpaks.nixosModules.nix-flatpak
      inputs.home-manager.nixosModules.home-manager
      {
        nixpkgs.config.allowUnfree = true;
        networking.hostName = hostname;
        system.stateVersion = "26.05";
      }
    ];
  };
}
