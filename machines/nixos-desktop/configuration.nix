{
  config,
  pkgs,
  allPackages,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/efi";
    };
    limine = {
      enable = true;
      efiInstallAsRemovable = true;
      package = pkgs.limine-full;
      efiSupport = true;
      maxGenerations = 50;
      extraEntries = ''
        /Windows
          protocol: efi
          path: uuid(b3da0000-00e7-4ae8-b504-c46541252acb):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
      style = {
        wallpapers = [pkgs.nixos-artwork.wallpapers.catppuccin-macchiato.gnomeFilePath];

        # Catppuccin-Macchiato theme
        graphicalTerminal = {
          palette = "24273a;ed8796;a6da95;eed49f;8aadf4;f5bde6;8bd5ca;cad3f5";
          brightPalette = "5b6078;ed8796;a6da95;eed49f;8aadf4;f5bde6;8bd5ca;cad3f5";
          background = "24273a";
          foreground = "cad3f5";
          brightBackground = "5b6078";
          brightForeground = "cad3f5";
        };
      };
    };
  };

  nix.settings.trusted-users = ["@nix-admins"];

  fileSystems = {
    "/".options = ["compress=zstd:1"];
    "/home".options = ["compress=zstd:1"];
    "/nix".options = ["compress=zstd:1" "noatime"];
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.enableAllFirmware = true;

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
  zramSwap.enable = true;
  time.timeZone = "America/Mexico_City";

  desktop-environments.kde.enable = true;
  # desktop-environments.kde.enable = config.specialisation != {}; # Maybe later I'll have time to configure it
  # specialisation.hyprland.configuration = {
  #   desktop-environments.hyprland.enable = true;
  # };

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
    net-tools

    wayland-utils
    wl-clipboard
    openrgb-with-all-plugins
    kbd
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

    spiceUSBRedirection.enable = true;

    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
      # enableKvm = true; # won't let use Bridged config
    };
  };

  programs.virt-manager.enable = true;
  programs.ghidra.enable = true;

  programs.droidcam.enable = true;

  programs.dconf.enable = true;

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = false;
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
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = false;
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };

    sunshine = {
      enable = false;
      capSysAdmin = true;
      openFirewall = true;
    };

    cloudflare-warp = {
      enable = true;
    };

    samba = {
      enable = false;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.1. 192.168.2. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "public" = {
          "path" = "/srv/public";
          "browseable" = "yes";
          "read only" = "yes";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          # "force user" = "username";
          # "force group" = "groupname";
        };
        "private" = {
          "path" = "/srv/private";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "naturalh";
          # "force group" = "groupname";
        };
      };
    };

    sshguard = {
      enable = true;
      blacklist_threshold = 120;
    };

    resolved = {
      enable = true;
      settings = {
        Resolve = {
          DNSOverTLS = "opportunistic";
          Domains = ["~."];
        };
      };
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
      nssmdns6 = true;
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
  # system.stateVersion = "25.11"; # Did you read the comment?
}
