{...}: {
  imports = [
    ./problematic-pkgs/packettracer/packettracer.nix
    ./programs/blender/blender.nix
    ./nix/nix-gc.nix
  ];
}
