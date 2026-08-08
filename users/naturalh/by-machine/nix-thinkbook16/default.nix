{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config.rocmSupport = true;

  gtk = {
    enable = true;
    colorScheme = "dark";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = let
      variant = "macchiato";
      accent = "lavender";
      size = "standard";
    in {
      name = "catppuccin-${variant}-${accent}-${size}";
      package = pkgs.catppuccin-gtk.override {
        inherit variant size;
        accents = [accent];
      };
    };
    cursorTheme = {
      name = "Macciato-Dark";
      package = pkgs.catppuccin-cursors.macchiatoDark;
    };
    font = {
      name = "Lexend";
      size = 10;
      package = pkgs.lexend;
    };
    gtk4.theme = config.gtk.theme;
  };
}
