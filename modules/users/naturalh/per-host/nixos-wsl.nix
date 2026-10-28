{
  self,
  inputs,
  ...
}: {
  flake.homeModules."naturalh@nixos-wsl" = {...}: {
    services.gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };
  };
}
