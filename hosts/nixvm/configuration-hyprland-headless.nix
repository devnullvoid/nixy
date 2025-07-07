# Hyprland with headless backend fallback for VirtIO-GPU
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

  # Environment variables for headless backend fallback
  environment.variables = {
    # Force software rendering
    "WLR_RENDERER" = "pixman";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "LIBGL_ALWAYS_SOFTWARE" = "1";
    "GALLIUM_DRIVER" = "llvmpipe";
    "MESA_LOADER_DRIVER_OVERRIDE" = "swrast";
    
    # Force headless backend if DRM fails
    "WLR_BACKENDS" = "drm,headless";
    "WLR_DRM_DEVICES" = "/dev/dri/card0";
    
    # Legacy wlroots flags
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_NO_SD_NOTIFY" = "1";
    "WLR_DRM_NO_ATOMIC" = "1";
    "WLR_DRM_NO_MODIFIERS" = "1";
    
    # Additional compatibility flags
    "WLR_DRM_NO_ATOMIC_GAMMA" = "1";
    "WLR_DRM_NO_PREFERRED" = "1";
    
    # Debug flags
    "HYPRLAND_LOG_WLR" = "1";
    "WAYLAND_DEBUG" = "1";
    "WLR_DRM_DEBUG" = "1";
  };

  # Use old Hyprland from 24.05 (pre-Aquamarine)
  environment.systemPackages = with pkgs; [
    # Use older Hyprland version
    oldPkgs.hyprland
    
    # VNC server for headless backend
    oldPkgs.wayvnc
    
    # Basic terminals
    kitty
    foot
    alacritty
    
    # Basic tools
    firefox
    
    # Debugging tools
    pciutils
    wayland-utils
    wlr-randr
    glxinfo
    mesa-demos
  ];

  # Create Hyprland desktop entry
  environment.etc."wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Comment=An intelligent dynamic tiling Wayland compositor
    Exec=${oldPkgs.hyprland}/bin/Hyprland
    Type=Application
  '';

  # SDDM configuration
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      General = {
        DefaultSession = "hyprland.desktop";
      };
    };
  };

  # Create a Hyprland config optimized for headless backend
  environment.etc."hyprland/hyprland.conf".text = ''
    # Hyprland config optimized for headless backend
    
    # Disable all effects and animations
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        vfr = false
        vrr = 0
        no_direct_scanout = true
        cursor_zoom_factor = 1.0
        animate_manual_resizes = false
        animate_mouse_windowdragging = false
        disable_autoreload = true
    }
    
    # Minimal decoration
    decoration {
        rounding = 0
        drop_shadow = false
        blur {
            enabled = false
        }
    }
    
    # Disable animations completely
    animations {
        enabled = false
    }
    
    # Basic input
    input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0
        force_no_accel = true
    }
    
    # Basic keybinds
    $mainMod = SUPER
    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, C, killactive
    bind = $mainMod, M, exit
    bind = $mainMod, V, togglefloating
    bind = $mainMod, F, exec, firefox
    
    # Monitor configuration - try both DRM and headless
    monitor = ,preferred,auto,1
    monitor = HEADLESS-1,1024x768@60,0x0,1
    
    # Workspace configuration
    workspace = 1, monitor:HEADLESS-1, default:true
  '';

  # Enable VNC server for headless backend access
  systemd.user.services.wayvnc = {
    description = "VNC server for Wayland";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${oldPkgs.wayvnc}/bin/wayvnc 0.0.0.0 5900";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  # Open VNC port
  networking.firewall.allowedTCPPorts = [ 5900 ];

  # Networking
  networking = {
    hostName = "nixvm-hyprland-headless";
    networkmanager.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
} 