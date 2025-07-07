# Debug Step 4c: Variables without theme (no Stylix dependency)
{ config, lib, pkgs, ... }: {
  imports = [
    ../../nixos/nix.nix
    ../../nixos/home-manager.nix
    ../../nixos/users.nix
    ./bootloader.nix
    ./hardware-configuration.nix
    # Don't import variables.nix - define variables inline without theme
  ];

  # Define variables inline without theme import
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };
  
  config = {
    var = {
      hostname = "nixvm-debug-step4c";
      username = "jon";
      configDirectory = "/home/jon/Dev/nixy";
      keyboardLayout = "us";
      location = "Annapolis";
      timeZone = "America/New_York";
      defaultLocale = "en_US.UTF-8";
      extraLocale = "en_US.UTF-8";
      git = {
        username = "Jon Rogers";
        email = "67245+devnullvoid@users.noreply.github.com";
      };
      autoUpgrade = false;
      autoGarbageCollector = true;
    };

    # Home-manager configuration with complex program imports
    home-manager.users."${config.var.username}" = {
    imports = [
      # Add back the complex program configurations
      ../../home/programs/nvf          # Neovim
      ../../home/programs/git          # Git (complex config)
      ../../home/programs/kitty        # Terminal
      ../../home/programs/fetch        # System info
    ];
    
    home = {
      inherit (config.var) username;
      homeDirectory = "/home/" + config.var.username;
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