{
  lib,
  config,
  pkgs,
  ...
}: {
  options.desktop-environments.kde.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the KDE Plasma desktop environment.";
  };

  config = lib.mkIf config.desktop-environments.kde.enable {
    environment.systemPackages = with pkgs.kdePackages; [
      kcalc
      kcharselect
      kcolorchooser
      kolourpaint
      ksystemlog
      sddm-kcm
      kamera
      filelight
      isoimagewriter
      partitionmanager
      bluedevil
      bluez-qt
      qtlocation
      krdp
      kclock
      kdenetwork-filesharing
      (skanpage.override {
        tesseractLanguages = ["eng" "deu" "fra" "spa"];
      })
      pkgs.kdiff3
      pkgs.nil
      pkgs.hardinfo2
      pkgs.haruna

      # for bluetooth support
      pkgs.openobex
      pkgs.obexftp

      (pkgs.catppuccin-sddm.override {
        flavor = "macchiato";
        accent = "lavender";
        font = "Lexend";
        fontSize = "10";
        background = let
          repo = pkgs.fetchFromGitHub {
            owner = "zhichaoh";
            repo = "catppuccin-wallpapers";
            rev = "1023077979591cdeca76aae94e0359da1707a60e";
            hash = "sha256-h+cFlTXvUVJPRMpk32jYVDDhHu1daWSezFcvhJqDpmU=";
          };
        in "${repo}/solids/bkg2.png";
        loginBackground = true;
      })
    ];

    programs = {
      steam = {
        package = pkgs.steam.override {
          extraPkgs = p: [
            p.kdePackages.breeze
          ];
        };
      };
      firefox.preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };

    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        settings.General.DisplayServer = "wayland";
        theme = "catppuccin-macchiato-lavender";
      };
    };
  };
}
