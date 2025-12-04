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
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-old";
    };
  };
}
