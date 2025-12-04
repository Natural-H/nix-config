{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    programs.blender = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Blender.";
      };

      useHip = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use HIP-capable Blender build for AMD GPUs.";
      };
    };
  };

  config = lib.mkIf config.programs.blender.enable {
    home.packages = with pkgs; [
      (
        if config.programs.blender.useHip
        then blender-hip
        else blender
      )
    ];
  };
}
