{
  self,
  inputs,
  ...
}: {
  flake.homeModules.perHostNaturalh = {hostname, ...}: let
    userhost = "naturalh@${hostname}";
    hasHostConfig = builtins.hasAttr userhost self.homeModules;
  in {
    imports = [
      (
        if hasHostConfig
        then self.homeModules.${userhost}
        else {}
      )
    ];
  };
}
