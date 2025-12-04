{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    problematicPrograms = {
      useCiscoPacketTracer = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to install Cisco Packet Tracer, which now have security issues with itself and one of its dependencies.";
      };
    };
  };

  config = lib.mkIf config.problematicPrograms.useCiscoPacketTracer {
    nixpkgs.config.permittedInsecurePackages = [
      "libxml2-2.13.8"
      "ciscoPacketTracer8-8.2.2" # This is getting ugly
    ];

    home.packages = with pkgs; [
      ciscoPacketTracer8
    ];
  };
}
