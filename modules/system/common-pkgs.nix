{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    os-prober
    openssh
    home-manager
    p7zip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}