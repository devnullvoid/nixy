{ pkgs, config, inputs, ... }: {
  imports = [
    # Essential inputs only
    inputs.nix-index-database.hmModules.nix-index
    ./variables.nix

    # Only essential programs for basic Hyprland testing
    ../../home/programs/shell        # Minimal shell (fish/zsh have lots of deps)
    ../../home/programs/git          # Git (essential for flake work)
    ../../home/programs/kitty        # Terminal
    
    # Core Hyprland system only (no extras)
    ../../home/system/hyprland       # Window manager
    ../../home/system/hyprpaper      # Wallpaper
    ../../home/system/hyprlock       # Screen lock
    ../../home/system/wofi           # App launcher
    ../../home/system/mime           # MIME types
    
    # Removed for minimal VM:
    # ../../home/programs/nvf          # HEAVY: Full Neovim setup with many plugins
    # ../../home/programs/git/signing.nix  # GPG signing not essential
    # ../../home/programs/gpg          # GPG not essential for testing
    # ../../home/programs/fetch        # System info tools
    # ../../home/programs/thunar       # HEAVY: File manager + icon themes
    # ../../home/programs/qutebrowser  # HEAVY: Browser with custom homepage
    # ../../home/programs/duckduckgo-colorscheme
    # ../../home/programs/anyrun       # HEAVY: Launcher with dependencies
    
    # Removed ALL scripts (save significant space):
    # ../../home/scripts/*             # All scripts add dependencies
    
    # Removed heavy Hyprland components:
    # ../../home/system/hypridle       # Idle management not essential
    # ../../home/system/hyprpanel      # HEAVY: Panel with many deps
    # ../../home/system/zathura        # PDF viewer not essential
    # ../../home/system/udiskie        # Auto-mount not essential  
    # ../../home/system/clipman        # Clipboard manager not essential
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Absolute minimum packages only
      firefox                        # Browser (needed for testing)
      
      # Basic utilities only
      tree                          # File tree viewer
      btop                          # System monitor
      
      # Removed to save space:
      # just                         # Command runner (build scripts work without it)
      # zip/unzip                    # Not essential for basic testing
      # jq                           # JSON processor
      # file                         # File type detection  
      # pfetch                       # System info
    ];

    # Don't touch this
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
} 