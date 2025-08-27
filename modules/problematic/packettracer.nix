{ config, pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "libxml2-2.13.8"
  ];

  home.packages = with pkgs; [
    ciscoPacketTracer8
  ];
}
