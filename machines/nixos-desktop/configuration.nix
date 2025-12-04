{
  config,
  pkgs,
  allPackages,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos/kde/plasma.nix
  ];

  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
      # canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      fsIdentifier = "label";
      copyKernels = true;
      useOSProber = true;
      efiInstallAsRemovable = true;
      splashImage = null;
      theme = pkgs.stdenv.mkDerivation {
        pname = "distro-grub-themes";
        version = "3.2";
        src = pkgs.fetchFromGitHub {
          owner = "AdisonCavani";
          repo = "distro-grub-themes";
          rev = "v3.2";
          hash = "sha256-U5QfwXn4WyCXvv6A/CYv9IkR/uDx4xfdSgbXDl5bp9M=";
        };
        installPhase = ''
          mkdir -p customize
          tar -xf themes/nixos.tar -C customize
          cp -r customize $out
        '';
      };
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

  nix-linker = {
    enable = true;
    includeGuiLibraries = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    os-prober
    openssh
    home-manager
    p7zip
    unrar
    geoclue2

    wayland-utils
    wl-clipboard
    openrgb-with-all-plugins
  ];

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = ["--all" "--volumes"];
      };
    };

    libvirtd = {
      enable = true;
    };
  };

  programs.virt-manager.enable = true;

  programs.dconf.enable = true;

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.git = {
    enable = true;
    config = {
      safe.directory = ["/etc/nixos"];
    };
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
      # upstream is broken for the time being
      package = allPackages.pkgs-unstable.tailscale;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [hplip];
      cups-pdf = {
        enable = true;
        instances = {
          pdf = {
            settings = {
              Out = "\${HOME}/cups-pdf";
              UserUMask = "0033";
            };
          };
        };
      };
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    geoclue2 = {
      enable = true;
    };

    joycond = {
      enable = true;
    };

    # I don't use it that much, but it's good to test stuff
    flatpak.enable = true;

    hardware = {
      openrgb.enable = true;
    };
  };

  location.provider = "geoclue2";

  hardware.bluetooth.enable = true; # Enable Bluetooth support
  hardware.xpadneo.enable = true;

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
