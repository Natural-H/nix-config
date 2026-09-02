{
  self,
  inputs,
  ...
}: let
  username = "mikeus";
in {
  flake.homeModules.${username} = {
    pkgs,
    stateVersion,
    ...
  }: {
    home.username = "${username}";
    home.homeDirectory = "/home/${username}";
    home.stateVersion = stateVersion;

    home.packages = with pkgs; [
      lazygit
      lazydocker
      gitkraken
      tree
      btop
      xclip
      lazysql
      (prismlauncher.override {
        jdks = [
          zulu8
          zulu17
          zulu
        ];
      })

      brave
      vscode
      libreoffice-qt6
      vesktop
      mission-center
      blender

      obs-studio
      imagemagick
      ffmpeg
      mangohud
      mangojuice
      nvtopPackages.amd

      dotnetCorePackages.dotnet_9.sdk

      wineWow64Packages.waylandFull
      desktop-file-utils
      osu-lazer-bin
    ];

    programs.git = {
      enable = true;
      settings = {
        user.name = "mikeus";
        user.email = "mikeleche1232@outlook.com";

        safe.directory = ["/etc/nixos"];
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = false;
      history = {
        size = 10000;
        share = false;
      };
      historySubstringSearch = {
        enable = true;
        searchDownKey = "^[OB";
        searchUpKey = "^[OA";
      };

      shellAliases = {
        pbcopy = "xclip -selection clipboard";
        pbpaste = "xclip -selection clipboard -o";
        amogos = "home-manager switch --flake /etc/nixos; update-desktop-database";
      };
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
