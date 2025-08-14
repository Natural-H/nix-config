# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../bootloader.nix
    ../../../modules/system/common-pkgs.nix
    ../../../modules/system/common-graphical.nix
    ../../../modules/kde/kde.nix
    ../../../modules/fonts/fonts.nix
    ../../../users/naturalh.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos-laptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  zramSwap.enable = true;

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # List services that you want to enable:

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings.General.DisplayServer = "wayland";
    };

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

    printing.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  # ];

  hardware.bluetooth.enable = true; # Enable Bluetooth support

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = { # hardware.graphics since NixOS 24.11
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  }; # Force intel-media-driver

  # Enable support for webcam
  # I need this even if I don't have Raptor Lake+ cpu
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6ep";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # services.openssh.settings.PermitRootLogin = "no";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8443 ]; # a docker service I use
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
