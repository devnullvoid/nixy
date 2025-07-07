# Debug Step 4: Add complex program configurations
{ config, lib, pkgs, ... }: {
  imports = [
    ../../nixos/nix.nix
    ../../nixos/home-manager.nix
    ../../nixos/users.nix
    ./bootloader.nix
    ./hardware-configuration.nix
  ];

  # Define minimal variables inline
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };
  
  config = {
    var = {
      hostname = "nixvm-debug-step4";
      username = "jon";
      autoGarbageCollector = false;
      git = {
        username = "Jon Rogers";
        email = "67245+devnullvoid@users.noreply.github.com";
      };
    };

    # Home-manager configuration with complex program imports
    home-manager.users.jon = {
      imports = [
        # Add back the complex program configurations that failed before
        ../../home/programs/nvf          # Neovim
        ../../home/programs/git          # Git (complex config)
        ../../home/programs/kitty        # Terminal
        ../../home/programs/fetch        # System info
      ];
      
      home = {
        username = "jon";
        homeDirectory = "/home/jon";
        stateVersion = "25.05";
        
        # Add basic packages
        packages = with pkgs; [
          firefox
          curl
          wget
          htop
          tree
          file
          unzip
        ];
      };
      
      # Enable XDG directories
      xdg.enable = true;
      
      programs.home-manager.enable = true;
      
      # Add minimal shell configuration
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
    };

    # Ensure shells and basic tools are available
    environment.systemPackages = with pkgs; [
      bash
      fish
      zsh
      coreutils
      util-linux
    ];

    # Basic system services
    services.openssh.enable = lib.mkForce false;
    networking.networkmanager.enable = lib.mkForce false;
    
    system.stateVersion = "25.05";
  };
} 