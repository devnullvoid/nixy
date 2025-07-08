{ pkgs, config, inputs, ... }: {
  imports = [
    # Flake inputs
    inputs.nix-index-database.hmModules.nix-index
    ./variables.nix

    # Essential programs for flake testing
    ../../home/programs/nvf          # Neovim
    ../../home/programs/shell        # Full shell config for testing
    ../../home/programs/git          # Git
    ../../home/programs/git/signing.nix
    ../../home/programs/gpg          # GPG for testing
    ../../home/programs/kitty        # Terminal
    ../../home/programs/fetch        # System info
    ../../home/programs/thunar       # File manager
    ../../home/programs/lazygit      # Git UI
    ../../home/programs/qutebrowser  # Browser for testing
    ../../home/programs/duckduckgo-colorscheme
    ../../home/programs/tailscale    # VPN for testing
    ../../home/programs/anyrun       # Launcher
    
    # All scripts for testing
    ../../home/scripts               # All scripts
    
    # Full Hyprland system for flake testing
    ../../home/system/hyprland       # Window manager
    ../../home/system/hyprpaper      # Wallpaper
    ../../home/system/hypridle       # Idle management
    ../../home/system/hyprlock       # Screen lock
    ../../home/system/hyprpanel      # Panel
    ../../home/system/wofi           # App launcher
    ../../home/system/zathura        # PDF viewer
    ../../home/system/mime           # MIME types
    ../../home/system/udiskie        # Auto-mount
    ../../home/system/clipman        # Clipboard manager
    
    # Skip heavy user applications only:
    # ../../home/programs/zen          # Heavy browser
    # ../../home/programs/discord      # Chat app
    # ../../home/programs/spicetify    # Spotify theming
    # ../../home/programs/nextcloud    # Cloud sync
    # ../../home/programs/tailscale    # VPN
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Essential apps for flake testing
      firefox                        # Web browser
      bitwarden                      # Password manager (for testing)
      vlc                           # Video player
      gnome-calendar                # Calendar
      textpieces                    # Text manipulation
      mpv                           # Video player
      
      # Development tools
      go
      bun
      nodejs
      python3
      jq
      just
      pnpm
      air
      
      # System utilities
      zip
      unzip
      optipng
      jpegoptim
      pfetch
      btop
      fastfetch
      htop
      tree
      file
      
      # Fun terminal apps
      peaclock
      cbonsai
      pipes
      cmatrix
      
      # Skip the heaviest packages:
      # obsidian                     # Note taking (Electron app)
      # figma-linux                  # Design tool
      # blanket                      # White noise (optional)
      # resources                    # System monitor (optional)
    ];

    # Don't copy profile picture for VM
    # file.".face.icon" = {source = ./profile_picture.png;};

    # Don't touch this
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
} 