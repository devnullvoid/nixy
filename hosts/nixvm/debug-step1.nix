# Debug Step 1: Add basic home-manager
{ config, lib, pkgs, ... }: {
  imports = [
    ../../nixos/nix.nix
    ../../nixos/home-manager.nix  # Add home-manager back
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
      hostname = "nixvm-debug-step1";
      username = "jon";
      autoGarbageCollector = false;
    };

    # Minimal user configuration
    users.users.jon = {
      isNormalUser = true;
      description = "jon account";
      extraGroups = [ "wheel" ];
      initialPassword = "jon";
      shell = pkgs.bash;  # Keep bash for now
      home = "/home/jon";
      createHome = true;
    };

    # Basic home-manager configuration (minimal)
    home-manager.users.jon = {
      home = {
        username = "jon";
        homeDirectory = "/home/jon";
        stateVersion = "25.05";
      };
      programs.home-manager.enable = true;
    };

    # Ensure bash is available
    environment.systemPackages = with pkgs; [
      bash
      coreutils
      util-linux
    ];

    # Basic system services
    services.openssh.enable = lib.mkForce false;
    networking.networkmanager.enable = lib.mkForce false;
    
    system.stateVersion = "25.05";
  };
} 