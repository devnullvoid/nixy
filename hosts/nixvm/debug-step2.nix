# Debug Step 2: Add shell configuration
{ config, lib, pkgs, ... }: {
  imports = [
    ../../nixos/nix.nix
    ../../nixos/home-manager.nix
    ../../nixos/users.nix  # Add back user configuration with shells
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
      hostname = "nixvm-debug-step2";
      username = "jon";
      autoGarbageCollector = false;
    };

    # Basic home-manager configuration with minimal shell
    home-manager.users.jon = {
      home = {
        username = "jon";
        homeDirectory = "/home/jon";
        stateVersion = "25.05";
      };
      programs.home-manager.enable = true;
      
      # Add minimal shell configuration
      programs.bash = {
        enable = true;
        shellAliases = {
          ll = "ls -la";
          la = "ls -la";
          c = "clear";
        };
      };
    };

    # Ensure shells are available
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