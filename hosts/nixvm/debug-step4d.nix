# Debug Step 4d: Pass system variables to home-manager context
{ config, lib, pkgs, ... }: {
  imports = [
    ../../nixos/nix.nix
    ../../nixos/home-manager.nix
    ../../nixos/users.nix
    ./bootloader.nix
    ./hardware-configuration.nix
  ];

  # Define variables inline without theme import
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };
  
  config = {
    var = {
      hostname = "nixvm-debug-step4d";
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

    # Home-manager configuration with variables passed down
    home-manager.users."${config.var.username}" = { config, lib, pkgs, ... }: {
      # Import complex program configurations
      imports = [
        ../../home/programs/git          # Git (complex config)
        ../../home/programs/kitty        # Terminal
        ../../home/programs/fetch        # System info
        # Skip nvf for now - it might have additional dependencies
      ];
      
      # Pass system variables to home-manager context
      options.var = lib.mkOption {
        type = lib.types.attrs;
        default = {};
      };
      
      config = {
        # Copy variables from system level
        var = {
          git = {
            username = "Jon Rogers";
            email = "67245+devnullvoid@users.noreply.github.com";
          };
        };
        
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