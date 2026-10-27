{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.sops-nix = {lib, ...}: {
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;

      age = {
        keyFile = lib.mkDefault "/home/naturalh/.config/sops/age/keys.txt";
        generateKey = true;
      };
    };
  };
}
