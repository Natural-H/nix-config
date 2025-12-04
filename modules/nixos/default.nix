{name, ...}: {
  imports = [
    ./fonts/fonts.nix
    ./nix/nix-linker.nix
    ./nix/nix-gc.nix
  ];

  networking.hostName = name;
  nixpkgs.config.allowUnfree = true;
  users.groups.nix-admins = {};
}
