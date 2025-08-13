{ config, pkgs, inputs, ... }:
{
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      fsIdentifier = "label";
      copyKernels = true;
      useOSProber = true;
      # efiInstallAsRemovable = true;
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
}