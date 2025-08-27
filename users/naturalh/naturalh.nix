{ pkgs, inputs, ... }:
{
  users.users.naturalh = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "nix-admins"
      "dialout"
      "uucp"
      "wheel"
      "docker"
    ];
    initialPassword = "password";
  };
}