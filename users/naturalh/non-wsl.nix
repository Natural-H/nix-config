{
  lib,
  isWsl,
  pkgs,
  allPackages,
  config,
  ...
}: {
  config = lib.mkIf (!isWsl) {
    # Okay, maybe I need some after all
    services = {
      flatpak = {
        enable = true;
        packages = [
          "com.usebottles.bottles"
          "com.github.tchx84.Flatseal"
          "net.xmind.XMind"
          "com.super_productivity.SuperProductivity"
        ];

        overrides = {
          "com.usebottles.bottles".Context = {
            filesystems = ["xdg-data/applications" "xdg-documents"];
          };
        };

        update.auto = {
          enable = true;
          onCalendar = "weekly";
        };
      };

      vscode-server = {
        enable = true;
        enableFHS = true;
      };
    };

    # problematicPrograms.ciscoPacketTracer8.enable = true;

    programs.blender = {
      enable = true;
      useHip = true;
    };

    home.packages = with pkgs; [
      osu-lazer-bin
      parsec-bin
      ryubing
      (prismlauncher.override {
        jdks = [
          allPackages.graalvm21
          zulu8
          zulu17
          zulu
        ];
      })
      lutris
      heroic

      libreoffice-qt6
      hunspellDicts.es_MX
      hunspellDicts.en_US
      chromium
      vesktop
      telegram-desktop
      obsidian
      simulide
      obs-studio
      thunderbird
      remmina
      jetbrains-toolbox
      wineWowPackages.waylandFull
      transmission_4-qt6
      nix-index
      nextcloud-client

      vscode
      android-tools
      dbeaver-bin
      distrobox
      openssl
      arduino-ide
      qtcreator
      # kdePackages.full # removed from upstream
      putty
      screen

      mangohud
      mangojuice # upstream doesn't have the has updated
      nvtopPackages.amd

      drawio
      librecad
      coppwr
      jamesdsp
      mission-center
      imagemagick
      ffmpeg
      handbrake
      gimp
      inkscape
      vlc

      kdePackages.qtstyleplugin-kvantum

      (pkgs.catppuccin-kvantum.override {
        variant = "macchiato";
        accent = "lavender";
      })
      (pkgs.catppuccin-kde.override {
        flavour = ["macchiato"];
        accents = ["lavender"];
      })
      catppuccin-cursors.macchiatoDark
    ];

    home.file = {
      "${config.xdg.configHome}/hypr" = {
        source = ./hyprland;
        recursive = true;
      };

      "${config.xdg.configHome}/waybar" = {
        source = ./waybar;
        recursive = true;
      };

      "${config.xdg.configHome}/rofi" = {
        source = ./rofi;
        recursive = true;
      };

      "${config.xdg.configHome}/swaync" = {
        source = ./swaync;
        recursive = true;
      };

      "${config.xdg.configHome}/hypr/config/pam.conf".text = ''
        exec-once = ${allPackages.pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init
      '';
    };
  };
}
