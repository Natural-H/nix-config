{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  hyprlandModule = import ./hyprland.nix {
    inherit inputs lib pkgs;
  };
in {
  options.desktop-environments.hyprland.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable use of a specialisation for Hyprland.";
  };

  config = lib.mkIf config.desktop-environments.hyprland.enable hyprlandModule;
}
