{pkgs, ...}: {
  users.users.naturalh = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "nix-admins"
      "dialout"
      "uucp"
      "wheel"
      "docker"
      "libvirtd"
      "kvm"
    ];
    initialPassword = "password";
  };
}
