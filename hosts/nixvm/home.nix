{ pkgs, config, inputs, ... }: {
  imports = [
    # Flake inputs
    inputs.nix-index-database.hmModules.nix-index
    ./variables.nix

    # Essential programs for flake testing
    ../../home/programs/nvf          # Neovim (needed for config editing)
    ../../home/programs/shell        # Shell config for testing
    ../../home/programs/git          # Git (essential for flake work)
    ../../home/programs/git/signing.nix
    ../../home/programs/gpg          # GPG for git signing
    ../../home/programs/kitty        # Terminal
    ../../home/programs/fetch        # System info
    ../../home/programs/thunar       # File manager (GUI testing)
    ../../home/programs/qutebrowser  # Lightweight browser for testing
    ../../home/programs/duckduckgo-colorscheme
    ../../home/programs/anyrun       # Launcher
    
    # Essential scripts only (removed heavy/unnecessary ones)
    ../../home/scripts/nixy          # Flake management scripts
    ../../home/scripts/screenshot    # Screenshot functionality
    ../../home/scripts/brightness    # Display brightness
    ../../home/scripts/night-shift   # Blue light filter
    ../../home/scripts/hyprpanel     # Panel scripts
    ../../home/scripts/hyprfocus     # Window focus scripts
    ../../home/scripts/notification  # Notification scripts
    ../../home/scripts/system        # System scripts
    
    # Full Hyprland system for flake testing
    ../../home/system/hyprland       # Window manager
    ../../home/system/hyprpaper      # Wallpaper
    ../../home/system/hypridle       # Idle management
    ../../home/system/hyprlock       # Screen lock
    ../../home/system/hyprpanel      # Panel
    ../../home/system/wofi           # App launcher
    ../../home/system/zathura        # PDF viewer (lightweight)
    ../../home/system/mime           # MIME types
    ../../home/system/udiskie        # Auto-mount
    ../../home/system/clipman        # Clipboard manager
    
    # Removed unnecessary modules:
    # ../../home/programs/lazygit      # Git UI (nvf has git integration)
    # ../../home/programs/tailscale    # VPN not needed in VM
    # ../../home/scripts/openvpn       # VPN scripts not needed
    # ../../home/scripts/caffeine      # Power management not needed in VM
    # ../../home/scripts/sounds        # Audio scripts not needed
    # ../../home/scripts/power-status  # Power management not needed in VM
    # ../../home/scripts/cleanup       # Not essential for testing
    # ../../home/scripts/nerdfont-fzf  # Optional font selector
    
    # Skip heavy user applications:
    # ../../home/programs/zen          # Heavy browser
    # ../../home/programs/discord      # Chat app
    # ../../home/programs/spicetify    # Spotify theming
    # ../../home/programs/nextcloud    # Cloud sync
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Essential apps for flake testing only
      firefox                        # Web browser (lighter than zen)
      
      # Minimal utilities
      zip
      unzip
      jq                            # JSON processor (useful for configs)
      tree                          # File tree viewer
      file                          # File type detection
      btop                          # System monitor
      pfetch                        # System info
      
      # Removed unnecessary packages:
      # Wine/Bottles related - none included
      # Audio/Video apps:
      # vlc                          # Video player
      # mpv                          # Video player  
      # Development tools:
      # go                           # Go SDK
      # bun                          # JS runtime
      # nodejs                       # Node.js
      # python3                      # Python
      # just                         # Command runner
      # pnpm                         # Package manager
      # air                          # Go live reload
      # Heavy apps:
      # bitwarden                    # Password manager
      # gnome-calendar               # Calendar
      # textpieces                   # Text manipulation
      # Fun/optional terminal apps:
      # peaclock                     # Terminal clock
      # cbonsai                      # Terminal bonsai
      # pipes                        # Terminal screensaver
      # cmatrix                      # Matrix effect
      # Image optimization tools:
      # optipng                      # PNG optimizer
      # jpegoptim                    # JPEG optimizer
      # htop                         # System monitor (btop is enough)
      # fastfetch                    # System info (pfetch is enough)
    ];

    # Don't copy profile picture for VM
    # file.".face.icon" = {source = ./profile_picture.png;};

    # Don't touch this
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
} 