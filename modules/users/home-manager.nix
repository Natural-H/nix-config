{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.home-manager = {
    config,
    isWsl,
    ...
  }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs isWsl;
        hostname = config.networking.hostName;
        stateVersion = config.system.stateVersion;
      };
    };
  };
}
