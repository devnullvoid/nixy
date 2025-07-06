{ pkgs, config, inputs, ... }: {
  imports = [
    # Mostly user-specific configuration
    inputs.nix-index-database.hmModules.nix-index
    ./variables.nix

    # Essential programs only
    ../../home/programs/nvf          # Neovim
    # ./fish-minimal.nix               # Minimal shell config (VM-safe) - disabled for now
    ../../home/programs/git          # Git
    ../../home/programs/kitty        # Terminal
    ../../home/programs/fetch        # System info
    
    # Hyprland essentials
    ../../home/system/hyprland       # Window manager
    ../../home/system/hyprpaper      # Wallpaper
    ../../home/system/hypridle       # Idle management
    ../../home/system/hyprlock       # Screen lock
    ../../home/system/hyprpanel      # Panel
    
    # Basic scripts
    ../../home/scripts/brightness    # Brightness control
    ../../home/scripts/screenshot    # Screenshots
    ../../home/scripts/notification  # Notifications
    ../../home/scripts/system        # System scripts
    
    # Skip resource-heavy or VM-unnecessary programs:
    # ../../home/programs/zen          # Browser - use Firefox instead
    # ../../home/programs/discord      # Not needed for testing
    # ../../home/programs/thunar       # File manager - use basic one
    # ../../home/programs/nextcloud    # Cloud sync not needed
    # ../../home/programs/qutebrowser  # Additional browser not needed
    # ../../home/programs/tailscale    # VPN not needed
    # ../../home/programs/gpg          # GPG not needed for testing
    # ../../home/system/sddm           # Display manager theming
    # ../../home/system/stylix         # Theming
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Essential apps for testing
      firefox                        # Web browser
      
      # Basic development tools
      git
      vim
      curl
      wget
      
      # System utilities
      htop
      tree
      file
      unzip
      
      # Minimal media
      # mpv                           # Video player
      
      # Basic file manager
      xfce.thunar
      
      # Don't include heavy packages:
      # bitwarden obsidian vlc blanket etc.
    ];

    # Don't copy profile picture for VM
    # file.".face.icon" = {source = ./profile_picture.png;};

    # Don't touch this
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
} 