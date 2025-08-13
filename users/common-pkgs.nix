{ config, pkgs,... }:
{
  programs.git = {
    enable = true;
    userName = "naturalh";
    userEmail = "marco.mmtz@proton.me";
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      LazyVim
    ];
  };

  home.packages = with pkgs; [
    lazygit
    lazydocker
    gitkraken
    tree
    btop
    xclip
  ];
}