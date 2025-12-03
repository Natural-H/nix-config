{
  nixpkgs,
  machines,
}:
nixpkgs.lib.foldlAttrs (
  acc: host: config:
    acc
    // nixpkgs.lib.listToAttrs (nixpkgs.lib.map (
        user: {
          name = "${user}@${host}";
          value = {
            inherit (config) system;
            inherit user;
            wsl = config.wsl or false;
            hardwareSpecific = nixpkgs.lib.recursiveUpdate {
              amd = {
                rocmCapable = false;
                hipCapable = false;
              };
            } (config.hardwareSpecific or {});
            problematicPrograms = nixpkgs.lib.recursiveUpdate {
              useCiscoPacketTracer = false;
            } (config.problematicPrograms or {});
          };
        }
      )
      config.users)
) {}
machines
