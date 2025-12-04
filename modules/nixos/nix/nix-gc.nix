{
  config,
  lib,
  ...
}: {
  options = {
    nix-gc.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable automatic garbage collection and optimization for Nix Store.";
    };
  };

  config = lib.mkIf config.nix-gc.enable {
    nix.settings.auto-optimise-store = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
