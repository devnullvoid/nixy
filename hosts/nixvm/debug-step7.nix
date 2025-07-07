# Debug Step 7: Include essential system services (don't disable them)
{ config, lib, pkgs, ... }: {
  imports = [
    ../../nixos/nix.nix
    ../../nixos/home-manager.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix      # Essential system services
    ../../nixos/fonts.nix      # Font support
    ./bootloader.nix
    ./hardware-configuration.nix
    ./variables.nix
  ];

  # Home-manager configuration
  home-manager.users."${config.var.username}" = {
    imports = [
      ./variables.nix
      ../../home/programs/git
      ../../home/programs/kitty
      ../../home/programs/fetch
    ];
    
    home = {
      inherit (config.var) username;
      homeDirectory = "/home/" + config.var.username;
      stateVersion = "25.05";
      
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
    
    xdg.enable = true;
    programs.home-manager.enable = true;
    
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

  # DON'T disable essential services - let utils.nix handle them
  # Remove these lines that were causing problems:
  # services.openssh.enable = lib.mkForce false;
  # networking.networkmanager.enable = lib.mkForce false;
  
  # VM-specific: Just don't import bluetooth module instead of disabling
  
  system.stateVersion = "25.05";
} 