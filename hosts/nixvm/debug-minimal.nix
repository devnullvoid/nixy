# Minimal debug configuration for nixvm
# This removes all potential sources of login issues
{ config, lib, pkgs, ... }: {
  imports = [
    ../../nixos/nix.nix
    ./bootloader.nix
    ./hardware-configuration.nix
    # Skip variables.nix (has theme imports)
    # Skip everything else that could cause issues
  ];

  # Define minimal variables inline
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };
  
  config = {
    var = {
      hostname = "nixvm-debug";
      username = "jon";
      autoGarbageCollector = false;
    };

    # Minimal user configuration
    users.users.jon = {
      isNormalUser = true;
      description = "jon account";
      extraGroups = [ "wheel" ];
      initialPassword = "jon";
      shell = pkgs.bash;  # Use bash only
      home = "/home/jon";
      createHome = true;
    };

    # Ensure bash is available
    environment.systemPackages = with pkgs; [
      bash
      coreutils
      util-linux
    ];

    # Basic system services only
    services.openssh.enable = lib.mkForce false;
    networking.networkmanager.enable = lib.mkForce false;
    
    # Skip home-manager entirely for this test
    # Skip all desktop environment stuff
    
    # Enable minimal console login
    services.getty.autologinUser = lib.mkForce null;
    
    system.stateVersion = "25.05";
  };
} 