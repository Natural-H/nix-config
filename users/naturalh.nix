{ ... }:
{
  users.users.naturalh = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };
}