{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configs/nix-hp-pavilion.nix
    ../modules/kde/plasma.nix
    ../modules/fonts/fonts.nix
  ];

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
  hardware.enableAllFirmware = true;

  networking.networkmanager.enable = true;
  zramSwap.enable = true;
  time.timeZone = "America/Mexico_City";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    os-prober
    openssh
    home-manager
    p7zip
    unrar
    geoclue2
    btrfs-progs
    lsof

    wayland-utils
    wl-clipboard
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  programs.dconf.enable = true;

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [hplip];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    geoclue2 = {
      enable = true;
    };

    tuned.enable = true;
  };

  location.provider = "geoclue2";

  hardware.bluetooth.enable = true; # Enable Bluetooth support

  # nixpkgs.config.packageOverrides = pkgs: {
  #   intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  # };
  hardware.graphics = {
    # hardware.graphics since NixOS 24.11
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
    # extraPackages = with pkgs; [
    #   intel-media-driver # LIBVA_DRIVER_NAME=iHD
    #   intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    #   libvdpau-va-gl
    # ];
  };
  # environment.sessionVariables = {
  #   LIBVA_DRIVER_NAME = "iHD";
  # }; # Force intel-media-driver

  # Enable support for webcam
  # I need this even if I don't have Raptor Lake+ cpu
  # hardware.ipu6.enable = true;
  # hardware.ipu6.platform = "ipu6ep";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
