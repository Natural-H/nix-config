{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs.kdePackages; [
    # discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
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
    pkgs.kdiff3
    pkgs.nil

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
}