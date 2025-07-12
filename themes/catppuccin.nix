{
  lib,
  pkgs,
  config,
  ...
}: {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = {
      rounding = 15;
      gaps-in = 8;
      gaps-out = 8 * 2;
      active-opacity = 0.90;
      inactive-opacity = 0.85;
      blur = true;
      border-size = 2;
      animation-speed = "fast"; # "fast" | "medium" | "slow"
      fetch = "none"; # "nerdfetch" | "neofetch" | "pfetch" | "none"
      textColorOnWallpaper =
        config.lib.stylix.colors.base05; # Color of the text displayed on the wallpaper (Lockscreen, display manager, ...)

      bar = {
        # Hyprpanel
        position = "top"; # "top" | "bottom"
        transparent = true;
        transparentButtons = false;
        floating = true;
      };
    };
    description = "Theme configuration options";
  };

  config = {
    stylix = {
      enable = true;

      base16Scheme = {
        base00 = "1e1e2e"; # base
        base01 = "181825"; # mantle
        base02 = "313244"; # surface0
        base03 = "45475a"; # surface1
        base04 = "585b70"; # surface2
        base05 = "cdd6f4"; # text
        base06 = "f5e0dc"; # rosewater
        base07 = "b4befe"; # lavender
        base08 = "f38ba8"; # red
        base09 = "fab387"; # peach
        base0A = "f9e2af"; # yellow
        base0B = "a6e3a1"; # green
        base0C = "94e2d5"; # teal
        base0E = "89b4fa"; # blue
        base0D = "cba6f7"; # mauve
        base0F = "f2cdcd"; # flamingo
        base10 = "181825"; # mantle - darker background
        base11 = "11111b"; # crust - darkest background
        base12 = "eba0ac"; # maroon - bright red
        base13 = "f5e0dc"; # rosewater - bright yellow
        base14 = "a6e3a1"; # green - bright green
        base15 = "89dceb"; # sky - bright cyan
        base16 = "74c7ec"; # sapphire - bright blue
        base17 = "f5c2e7"; # pink - bright purple
      };

      cursor = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 20;
      };

      fonts = {
        monospace = {
          package = pkgs.monaspace;
          name = "Monaspace Krypton";
        };
        sansSerif = {
          package = pkgs.source-sans-pro;
          name = "Source Sans Pro";
        };
        serif = config.stylix.fonts.sansSerif;
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 13;
          desktop = 13;
          popups = 13;
          terminal = 13;
        };
      };

      polarity = "dark";
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master/cat-vibin.png";
        sha256 = "sha256-Hg27Gp4JBrYIC5B1Uaz8QkUskwD3pBhgEwE1FW7VBYo=";
      };
    };
  };
}