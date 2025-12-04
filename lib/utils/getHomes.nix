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
          value =
            removeAttrs
            (config
              // {
                inherit user;
              }) ["users"];
        }
      )
      config.users)
) {}
machines
