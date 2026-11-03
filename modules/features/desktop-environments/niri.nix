{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.desktop-environments.niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Niri as DE";
    };

    config = lib.mkIf config.desktop-environments.niri.enable {
      programs.niri = {
        enable = true;
        useNautilus = true;
      };

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-macchiato-lavender";
      };

      # services.gnome.gnome-keyring.enable = true;

      environment.systemPackages = with pkgs; [
        kitty
        alacritty
        noctalia
        fuzzel
        nwg-look
        kdePackages.kwallet-pam
        kdePackages.kwalletmanager
        kdePackages.kwallet
        kdePackages.qt6ct
        # seahorse

        (pkgs.catppuccin-sddm.override {
          flavor = "macchiato";
          accent = "lavender";
          font = "Lexend";
          fontSize = "10";
          background = let
            repo = pkgs.fetchFromGitHub {
              owner = "zhichaoh";
              repo = "catppuccin-wallpapers";
              rev = "1023077979591cdeca76aae94e0359da1707a60e";
              hash = "sha256-h+cFlTXvUVJPRMpk32jYVDDhHu1daWSezFcvhJqDpmU=";
            };
          in "${repo}/solids/bkg2.png";
          loginBackground = true;
        })
      ];

      security.pam.services = {
        login = {
          # using sddm won't work
          enable = true;
          # kwallet.enable = true;
          # enableGnomeKeyring = true;
          enableKwallet = true;
        };

        sddm = {
          enable = true;
          # enableGnomeKeyring = true;
          enableKwallet = true;
        };
      };
    };
  };
}
