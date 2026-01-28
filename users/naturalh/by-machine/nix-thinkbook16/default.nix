{pkgs, ...}: {
  gtk = {
    enable = true;
    colorScheme = "dark";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
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
  };
}
