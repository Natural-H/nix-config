{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.permittedInsecurePackages = [
    "libxml2-2.13.8"
    "ciscoPacketTracer8-8.2.2" # This is getting ugly
  ];

  home.packages = with pkgs; [
    ciscoPacketTracer8
  ];
}
