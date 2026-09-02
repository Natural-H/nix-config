{
  self,
  inputs,
  ...
}: {
  flake.homeModules."naturalh@nixos-wsl" = {...}: {
    services.pass-secret-service.enable = true;
  };
}
