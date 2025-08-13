{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    vscode
    libreoffice-qt6
    vesktop
    mission-center
    blender
    osu-lazer
    prismlauncher
    nextcloud-client
    transmission_4-qt6
    xournalpp
    texliveFull
    texlivePackages.latex
    obs-studio
    telegram-desktop
    imagemagick

    jdk24
    jetbrains-toolbox
    dotnetCorePackages.dotnet_9.sdk

    wineWowPackages.waylandFull
  ];
}