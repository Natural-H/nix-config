{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    fonts.includeCommon = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include a set of commonly used fonts in the system.";
    };
  };

  config = lib.mkIf config.fonts.includeCommon {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.droid-sans-mono
      corefonts
      vista-fonts
      oswald
      lexend
      roboto
    ];
  };
}
