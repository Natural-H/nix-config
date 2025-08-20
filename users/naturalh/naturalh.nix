{ pkgs, inputs, ... }:
{
  users.users.naturalh = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "users"
      "wheel"
      "docker"
    ];
  };
}