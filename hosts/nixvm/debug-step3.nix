# Debug Step 3: Add essential programs
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
      hostname = "nixvm-debug-step3";
      username = "jon";
      autoGarbageCollector = false;
    };

    # Home-manager configuration with essential programs
    home-manager.users.jon = {
      imports = [
        # Add back essential programs one by one
        ../../home/programs/nvf          # Neovim
        ../../home/programs/git          # Git
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
          git
          vim
          curl
          wget
          htop
          tree
          file
          unzip
        ];
      };
      
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