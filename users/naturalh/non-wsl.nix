{
  lib,
  isWsl,
  pkgs,
  allPackages,
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

      nextcloud-client = {
        enable = true;
        startInBackground = true;
      };

      vscode-server = {
        enable = true;
        enableFHS = true;
      };

      tailscale-systray = {
        enable = true;
      };
    };

    problematicPrograms.ciscoPacketTracer8.enable = true;

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
      nextcloud-client
      obsidian
      simulide
      obs-studio
      thunderbird
      remmina
      jetbrains-toolbox
      wineWowPackages.waylandFull
      transmission_4-qt6
      nix-index

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
      mangojuice
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
    ];
  };
}
