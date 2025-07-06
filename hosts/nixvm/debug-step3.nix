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
      git = {
        username = "Jon Rogers";
        email = "67245+devnullvoid@users.noreply.github.com";
      };
    };

    # Home-manager configuration with basic packages only
    home-manager.users.jon = {
      home = {
        username = "jon";
        homeDirectory = "/home/jon";
        stateVersion = "25.05";
        
        # Add basic packages (no complex program configs)
        packages = with pkgs; [
          firefox
          git
          neovim
          kitty
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
      
      # Basic git config without complex imports
      programs.git = {
        enable = true;
        userName = "Jon Rogers";
        userEmail = "67245+devnullvoid@users.noreply.github.com";
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