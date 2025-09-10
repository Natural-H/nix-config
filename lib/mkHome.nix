{ inputs, nixpkgs, nixpkgs-stable, ... }:

{
  system,
  user,
  wsl ? false,
  hardwareSpecific,
  problematicPrograms
}:
let
  isWsl = wsl;

  userConfig = ../users/${user}/home-manager.nix;

  createHome = inputs.home-manager.lib.homeManagerConfiguration;
in createHome rec {
  pkgs = nixpkgs.legacyPackages.${system};
  extraSpecialArgs = {
    inherit inputs isWsl;
    hardwareSpecific = hardwareSpecific;

    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };
  modules = [
    userConfig
    (if !isWsl then inputs.flatpaks.homeManagerModules.nix-flatpak else {})

    # {
    #   config._module.args = {
    #     inputs = inputs;
    #     currentSystem = system;
    #     isWsl = isWsl;
    #     hardwareSpecific = hardwareSpecific;
    #   };
    # }
  ] ++ (nixpkgs.lib.optionals (problematicPrograms.useCiscoPacketTracer) [
    ../modules/problematic/packettracer.nix
  ]);
}