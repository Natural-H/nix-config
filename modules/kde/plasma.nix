{ config, pkgs, inputs, ... }:
{
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
    kdenetwork-filesharing
    pkgs.kdiff3
    pkgs.nil
    pkgs.hardinfo2
    pkgs.haruna

    # for bluetooth support
    pkgs.openobex
    pkgs.obexftp
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
    };
  };
}