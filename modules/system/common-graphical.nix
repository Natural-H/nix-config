{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    hardinfo2
    haruna
    wayland-utils
    wl-clipboard
  ];

  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}