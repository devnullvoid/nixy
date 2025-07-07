# Simple Hyprland configuration for manual testing
{ config, pkgs, lib, inputs, ... }: 

let
  # Pin to nixpkgs-24.05 which should have pre-Aquamarine Hyprland
  oldPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
    sha256 = "0zydsqiaz8qi4zd63zsb2gij2p614cgkcaisnk11wjy3nmiq0x1s";
  }) { system = pkgs.system; };
in
{
  imports = [
    ../../nixos/nix.nix
    ./bootloader.nix
    ./hardware-configuration.nix
    ./variables-x11.nix  # Use simplified variables
  ];

  # Minimal user setup
  users.users.jon = {
    isNormalUser = true;
    description = "jon account";
    extraGroups = [ "wheel" "video" "render" "input" "kvm" ];
    initialPassword = "jon";
    shell = pkgs.bash;
  };

  # Basic VirtIO-GPU kernel configuration
  boot = {
    kernelModules = [ "virtio_gpu" "drm" "drm_kms_helper" ];
    kernelParams = [
      "virtio_gpu.force_probe=1"
      "virtio_gpu.modeset=1"
    ];
    initrd.kernelModules = [ "virtio_gpu" ];
  };

  # Basic hardware graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      virglrenderer
      libdrm
    ];
  };

  # Minimal environment variables
  environment.variables = {
    # Force software rendering
    "WLR_RENDERER" = "pixman";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "LIBGL_ALWAYS_SOFTWARE" = "1";
    
    # Basic compatibility
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_NO_SD_NOTIFY" = "1";
    
    # Debug flags
    "HYPRLAND_LOG_WLR" = "1";
    "WAYLAND_DEBUG" = "1";
  };

  # Use old Hyprland from 24.05 (pre-Aquamarine)
  environment.systemPackages = with pkgs; [
    # Use older Hyprland version
    oldPkgs.hyprland
    
    # VNC server for headless testing
    oldPkgs.wayvnc
    oldPkgs.tigervnc
    
    # Basic terminals
    kitty
    foot
    
    # Basic tools
    firefox
    
    # Debugging tools
    pciutils
    wayland-utils
    wlr-randr
    glxinfo
    mesa-demos
    
    # Additional debugging
    strace
    gdb
  ];

  # NO display manager - we'll test manually
  # services.displayManager.sddm.enable = false;

  # Create a minimal Hyprland config
  environment.etc."hyprland/hyprland.conf".text = ''
    # Minimal Hyprland config
    
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        vfr = false
        vrr = 0
    }
    
    decoration {
        rounding = 0
        drop_shadow = false
        blur {
            enabled = false
        }
    }
    
    animations {
        enabled = false
    }
    
    input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0
    }
    
    # Basic keybinds
    $mainMod = SUPER
    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, C, killactive
    bind = $mainMod, M, exit
    
    # Monitor configuration
    monitor = ,preferred,auto,1
  '';

  # Create test scripts for manual testing
  environment.etc."hyprland-test-scripts/test-drm.sh" = {
    text = ''
      #!/bin/bash
      echo "Testing Hyprland with DRM backend..."
      export WLR_BACKENDS="drm"
      export WLR_DRM_DEVICES="/dev/dri/card0"
      export WLR_RENDERER="pixman"
      export WLR_NO_HARDWARE_CURSORS="1"
      export LIBGL_ALWAYS_SOFTWARE="1"
      export HYPRLAND_LOG_WLR="1"
      
      echo "Environment variables set:"
      env | grep -E "(WLR_|HYPRLAND_|LIBGL_)"
      
      echo "Starting Hyprland with DRM backend..."
      ${oldPkgs.hyprland}/bin/Hyprland
    '';
    mode = "0755";
  };

  environment.etc."hyprland-test-scripts/test-headless.sh" = {
    text = ''
      #!/bin/bash
      echo "Testing Hyprland with headless backend..."
      export WLR_BACKENDS="headless"
      export WLR_RENDERER="pixman"
      export WLR_NO_HARDWARE_CURSORS="1"
      export LIBGL_ALWAYS_SOFTWARE="1"
      export HYPRLAND_LOG_WLR="1"
      
      echo "Environment variables set:"
      env | grep -E "(WLR_|HYPRLAND_|LIBGL_)"
      
      echo "Starting Hyprland with headless backend..."
      ${oldPkgs.hyprland}/bin/Hyprland &
      HYPRLAND_PID=$!
      
      sleep 2
      
      echo "Starting VNC server..."
      ${oldPkgs.wayvnc}/bin/wayvnc 0.0.0.0 5900 &
      VNC_PID=$!
      
      echo "Hyprland PID: $HYPRLAND_PID"
      echo "VNC PID: $VNC_PID"
      echo "Connect via VNC to this machine on port 5900"
      
      wait $HYPRLAND_PID
    '';
    mode = "0755";
  };

  environment.etc."hyprland-test-scripts/test-x11.sh" = {
    text = ''
      #!/bin/bash
      echo "Testing Hyprland with X11 backend..."
      export WLR_BACKENDS="x11"
      export WLR_RENDERER="pixman"
      export WLR_NO_HARDWARE_CURSORS="1"
      export LIBGL_ALWAYS_SOFTWARE="1"
      export HYPRLAND_LOG_WLR="1"
      export DISPLAY=":0"
      
      echo "Environment variables set:"
      env | grep -E "(WLR_|HYPRLAND_|LIBGL_|DISPLAY)"
      
      echo "Starting Hyprland with X11 backend..."
      ${oldPkgs.hyprland}/bin/Hyprland
    '';
    mode = "0755";
  };

  # Open VNC port
  networking.firewall.allowedTCPPorts = [ 5900 ];

  # Networking
  networking = {
    hostName = "nixvm-hyprland-simple";
    networkmanager.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
} 