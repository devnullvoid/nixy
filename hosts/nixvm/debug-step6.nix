# Debug Step 6: Import variables.nix in both contexts (like procyon)
{ config, lib, pkgs, ... }: {
  imports = [
    ../../nixos/nix.nix
    ../../nixos/home-manager.nix
    ../../nixos/users.nix
    ./bootloader.nix
    ./hardware-configuration.nix
    ./variables.nix  # System-level variables
  ];

  # Home-manager configuration with variables imported in home context
  home-manager.users."${config.var.username}" = {
    imports = [
      ./variables.nix  # Home-manager level variables (same file!)
      
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
} 