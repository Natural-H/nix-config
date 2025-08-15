{ pkgs, inputs, ... }:
{
  users.users.naturalh = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };
}