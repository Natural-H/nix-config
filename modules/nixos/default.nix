{...}: {
  imports = [
    ./fonts/fonts.nix
    ./nix/nix-linker.nix
    ./nix/nix-gc.nix
    ./desktop-environments/kde/plasma.nix
    ./desktop-environments/hyprland/default.nix
  ];
}
