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
            config
            // {
              inherit user;
              hostname = host;
            };
        }
      )
      config.users)
) {}
machines
