{ pkgs, config, inputs, ... }: {
  imports = [
    # Mostly user-specific configuration
    inputs.nix-index-database.hmModules.nix-index
    ./variables.nix

    # Essential programs only - skip heavy ones
    ../../home/programs/git          # Git
    ../../home/programs/kitty        # Terminal
    ../../home/programs/fetch        # System info
    # ../../home/programs/nvf          # Neovim - SKIP (heavy build)
    
    # Basic Hyprland setup - skip heavy theming
    ../../home/system/hyprland       # Window manager
    # ../../home/system/hyprpaper      # Wallpaper - SKIP
    # ../../home/system/hypridle       # Idle management - SKIP
    # ../../home/system/hyprlock       # Screen lock - SKIP
    # ../../home/system/hyprpanel      # Panel - SKIP (heavy build)
    
    # Skip all scripts for now
    # ../../home/scripts/brightness    # Brightness control
    # ../../home/scripts/screenshot    # Screenshots
    # ../../home/scripts/notification  # Notifications
    # ../../home/scripts/system        # System scripts
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
      
      # Basic file manager
      xfce.thunar
      
      # Terminal
      kitty
    ];

    # Don't touch this
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
  
  # Basic bash setup
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      la = "ls -la";
      c = "clear";
      vim = "nvim";
      vi = "nvim";
    };
  };
} 