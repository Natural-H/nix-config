{
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
    portalPackage = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".xdg-desktop-portal-hyprland;
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      # Point this to the start-hyprland wrapper instead of the raw binary
      binPath = lib.mkForce "/run/current-system/sw/bin/start-hyprland";
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.baloo
    kdePackages.baloo-widgets
    kdePackages.kcmutils
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.qtstyleplugin-kvantum
    kdePackages.polkit-kde-agent-1
    kdePackages.filelight
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
    kdePackages.kservice
    kdePackages.konsole

    kitty
    alacritty
    waybar
    hyprpaper
    rofi
    wlogout
    swaynotificationcenter

    nautilus

    system-config-printer

    killall

    kdePackages.qt6ct
    nwg-look

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
      in "${repo}/minimalistic/gradient-synth-cat.png";
      loginBackground = true;
    })
  ];

  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      hyprland = {
        default = ["hyprland" "gtk"];
        # "org.freedesktop.impl.portal.FileChooser" = "kde";
      };
    };
  };

  security.rtkit.enable = true;
  services.gvfs.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    # defaultSession = "hyprland";
    theme = "catppuccin-macchiato-lavender";
  };

  security.pam.services = {
    login = {
      # using sddm won't work
      enable = true;
      kwallet.enable = true;
    };
  };
}
