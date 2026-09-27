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
            # "com.usebottles.bottles"
            "com.github.tchx84.Flatseal"
            "net.xmind.XMind"
            "org.gaphor.Gaphor"
          ];

          # overrides = {
          #   "com.usebottles.bottles".Context = {
          #     filesystems = ["xdg-data/applications" "xdg-documents"];
          #   };
          # };

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

      home.packages = with pkgs;
        [
          osu-lazer-bin
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
          moonlight-qt

          libreoffice-qt6
          onlyoffice-desktopeditors
          hunspellDicts.es_MX
          hunspellDicts.en_US
          chromium
          brave
          vesktop
          telegram-desktop
          obsidian
          obs-studio
          transmission_4-qt
          nextcloud-client
          blender

          vscode
          android-tools
          dbeaver-bin
          openssl

          mangohud
          mangojuice
          nvtopPackages.amd

          drawio
          jamesdsp
          mission-center
          imagemagick
          ffmpeg
          handbrake
          gimp
          vlc

          # self.packages.${pkgs.stdenv.hostPlatform.system}.ciscoPacketTracer901

          papirus-icon-theme
          kdePackages.qtstyleplugin-kvantum
          catppuccin-cursors.macchiatoDark
        ]
        ++ (let
          variant = "macchiato";
          accent = "lavender";
          size = "standard";
        in
          with pkgs; [
            (catppuccin-kde.override
              {
                flavour = [variant];
                accents = [accent];
              })
            (catppuccin-kvantum.override {
              inherit variant accent;
            })
            (catppuccin-gtk.override
              {
                inherit variant size;
                accents = [accent];
              })
          ]);

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
