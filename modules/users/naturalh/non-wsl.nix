{
  self,
  inputs,
  ...
}: {
  flake.homeModules.naturalhNonwsl = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options = {
      wsl = {
        useNonWsl = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };
    };

    config = lib.mkIf config.wsl.useNonWsl {
      # Okay, maybe I need some after all
      services = {
        flatpak = {
          enable = true;
          packages = [
            "com.usebottles.bottles"
            "com.github.tchx84.Flatseal"
            "net.xmind.XMind"
            "com.super_productivity.SuperProductivity"
            "org.gaphor.Gaphor"
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
          nodejsPackage = pkgs.nodejs;
        };
      };

      home.packages = with pkgs; [
        osu-lazer-bin
        parsec-bin
        ryubing
        (prismlauncher.override {
          jdks = [
            zulu8
            zulu17
            zulu21
            zulu25
          ];
        })
        retroarch-free
        heroic
        moonlight

        libreoffice-qt6
        onlyoffice-desktopeditors
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
        wineWow64Packages.waylandFull
        transmission_4-qt
        nix-index
        nextcloud-client
        blender

        vscode
        android-tools
        dbeaver-bin
        distrobox
        openssl
        arduino-ide
        putty
        screen

        mangohud
        mangojuice
        nvtopPackages.amd

        drawio
        librecad
        coppwr
        jamesdsp
        mission-center
        imagemagick
        ffmpeg
        # handbrake
        gimp
        inkscape
        vlc
        audacity
        filezilla

        self.packages.${pkgs.stdenv.hostPlatform.system}.ciscoPacketTracer901

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
          source = ./dotfiles/hyprland;
          recursive = true;
        };

        "${config.xdg.configHome}/waybar" = {
          source = ./dotfiles/waybar;
          recursive = true;
        };

        "${config.xdg.configHome}/rofi" = {
          source = ./dotfiles/rofi;
          recursive = true;
        };

        "${config.xdg.configHome}/swaync" = {
          source = ./dotfiles/swaync;
          recursive = true;
        };

        "${config.xdg.configHome}/hypr/config/pam.conf".text = ''
          exec-once = ${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init
        '';
      };
    };
  };
}
