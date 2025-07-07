# Headless-only configuration - guaranteed to work
{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  # Boot configuration
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/vda";
      useOSProber = true;
    };
  };

  # Basic system
  networking = {
    hostName = "hyprland-test-headless";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 5900 ]; # VNC
  };

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.test = {
    isNormalUser = true;
    description = "Test User";
    extraGroups = [ "wheel" ];
    initialPassword = "test";
    shell = pkgs.bash;
  };

  # No graphics needed for headless
  # hardware.opengl.enable = false;

  # Force headless backend only
  environment.variables = {
    "WLR_BACKENDS" = "headless";
    "WLR_RENDERER" = "pixman";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "LIBGL_ALWAYS_SOFTWARE" = "1";
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_LOG_WLR" = "1";
  };

  # Enable Hyprland (stable version)
  programs.hyprland.enable = true;

  # Basic packages + VNC
  environment.systemPackages = with pkgs; [
    kitty
    firefox
    git
    htop
    wayvnc
    tigervnc
  ];

  # No display manager - manual start only
  # services.displayManager.sddm.enable = false;

  # SSH for debugging
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Hyprland config for headless
  environment.etc."hypr/hyprland.conf".text = ''
    # Headless Hyprland config
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
    }
    
    decoration {
        rounding = 0
        drop_shadow = false
        blur { enabled = false }
    }
    
    animations { enabled = false }
    
    input {
        kb_layout = us
        follow_mouse = 1
    }
    
    $mainMod = SUPER
    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, C, killactive
    bind = $mainMod, M, exit
    
    # Headless monitor
    monitor = HEADLESS-1,1920x1080@60,0x0,1
  '';

  # Test script for headless Hyprland
  environment.etc."test-hyprland.sh" = {
    text = ''
      #!/bin/bash
      echo "Starting Hyprland in headless mode..."
      export WLR_BACKENDS="headless"
      export WLR_RENDERER="pixman"
      export HYPRLAND_LOG_WLR="1"
      
      # Start Hyprland in background
      Hyprland &
      HYPRLAND_PID=$!
      
      sleep 3
      
      # Start VNC server
      wayvnc 0.0.0.0 5900 &
      VNC_PID=$!
      
      echo "Hyprland PID: $HYPRLAND_PID"
      echo "VNC PID: $VNC_PID"
      echo "Connect via VNC to this machine on port 5900"
      echo "Press Ctrl+C to stop"
      
      trap "kill $HYPRLAND_PID $VNC_PID" EXIT
      wait $HYPRLAND_PID
    '';
    mode = "0755";
  };

  system.stateVersion = "24.05";
} 