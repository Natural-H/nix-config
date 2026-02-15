{pkgs, ...}: {
  users.users.mikeus = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "nix-admins"
      "wheel"
    ];
    initialPassword = "password";
  };
}
