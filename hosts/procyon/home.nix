{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    # Flake inputs
    inputs.nix-index-database.homeModules.nix-index
    inputs.dankMaterialShell.homeModules.dank-material-shell

    # Mostly user-specific configuration
    ./variables.nix

    # Programs
    ../../home/programs/kitty
    ../../home/programs/nvf
    ../../home/programs/shell
    ../../home/programs/fetch
    ../../home/programs/git
    ../../home/programs/git/signing.nix
    ../../home/programs/gpg
    ../../home/programs/spicetify
    ../../home/programs/nextcloud
    ../../home/programs/thunar
    ../../home/programs/lazygit
    ../../home/programs/zen
    ../../home/programs/qutebrowser
    ../../home/programs/duckduckgo-colorscheme
    ../../home/programs/discord
    ../../home/programs/tailscale
    ../../home/programs/anyrun
    ../../home/programs/zed
    ../../home/programs/helix
    ../../home/programs/firefox
    ../../home/programs/brave
    ../../home/programs/vscode
    ../../home/programs/terminals

    # Scripts
    ../../home/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../home/system/hyprland
    ../../home/system/hypridle
    ../../home/system/hyprlock
    ../../home/system/dankmaterialshell
    ../../home/system/niri
    ../../home/system/hyprpaper
    ../../home/system/wofi
    ../../home/system/zathura
    ../../home/system/mime
    ../../home/system/udiskie

    ./secrets # CHANGEME: You should probably remove this line, this is where I store my secrets
  ];

  programs.home-manager.enable = true;

  stylix.icons = {
    enable = true;
    package = pkgs.colloid-icon-theme.override {
      schemeVariants = ["catppuccin"];
      colorVariants = ["purple"];
    };
    light = "Colloid-Purple-Catppuccin-Light";
    dark = "Colloid-Purple-Catppuccin-Dark";
  };

  home = let
    wallpaperSample = inputs.wallpkgs.wallpapers.catppuccin."catppuccin-cat-vibin".path;
    wallpaperRoot = builtins.dirOf (builtins.dirOf wallpaperSample);
  in {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Apps
      bitwarden-desktop # Password manager
      vlc # Video player
      blanket # White-noise app
      obsidian # Note taking app
      # planify # Todolists
      gnome-calendar # Calendar
      textpieces # Manipulate texts
      curtail # Compress images
      resources
      gnome-clocks
      gnome-text-editor
      mpv # Video player
      figma-linux

      winbox4

      # Dev
      go
      bun
      nodejs
      python3
      jq
      just
      pnpm
      air

      # Nix
      nil
      alejandra
      statix
      nh
      nurl

      # Utils
      dua
      duf
      zip
      unzip
      optipng
      jpegoptim
      pfetch
      btop
      fastfetch
      colloid-icon-theme
      adwaita-icon-theme

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix

      # Backup
      kopia
      kopia-ui
      restic

      # Editors
      code-cursor
      windsurf

      (writers.writeDashBin "xterm" ''
        kitty "$@"
      '')
    ];

    # Set default terminal for all applications
    sessionVariables = {
      TERMINAL = "kitty";
      TERM = "kitty";
    };

    file = {
      ".face.icon" = {source = ./profile_picture.png;};
      "Pictures/wallpapers" = {
        source = wallpaperRoot;
        recursive = true;
      };
    };

    # Don't touch this
    stateVersion = "25.05";
  };
}
