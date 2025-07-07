# Hyprland configuration with EGL/OpenGL completely disabled
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

  # Environment variables to completely disable EGL/OpenGL
  environment.variables = {
    # Force pure software rendering
    "WLR_RENDERER" = "pixman";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    
    # Completely disable OpenGL/EGL
    "LIBGL_ALWAYS_SOFTWARE" = "1";
    "GALLIUM_DRIVER" = "llvmpipe";
    "MESA_LOADER_DRIVER_OVERRIDE" = "swrast";
    
    # Disable EGL completely
    "EGL_PLATFORM" = "surfaceless";
    "MESA_EGL_VERSION_OVERRIDE" = "1.4";
    "EGL_LOG_LEVEL" = "fatal";
    
    # Force wlroots to not use EGL
    "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
    
    # Disable hardware acceleration entirely
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_NO_SD_NOTIFY" = "1";
    
    # Additional software rendering flags
    "MESA_GL_VERSION_OVERRIDE" = "2.1";
    "MESA_GLSL_VERSION_OVERRIDE" = "120";
    
    # Disable GPU acceleration for applications
    "WEBKIT_DISABLE_COMPOSITING_MODE" = "1";
    "LIBVA_DRIVER_NAME" = "dummy";
    
    # Debug flags
    "HYPRLAND_LOG_WLR" = "1";
    "WAYLAND_DEBUG" = "1";
  };

  # Use old Hyprland from 24.05 (pre-Aquamarine)
  environment.systemPackages = with pkgs; [
    # Use older Hyprland version
    oldPkgs.hyprland
    
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

  # Create a very minimal Hyprland config that avoids OpenGL features
  environment.etc."hypr/hyprland.conf".text = ''
    # Minimal Hyprland config avoiding OpenGL features
    
    # Disable all GPU-dependent features
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
        enable_swallow = false
        swallow_regex = ^$
    }
    
    # Completely disable decorations to avoid GPU usage
    decoration {
        rounding = 0
        drop_shadow = false
        blur {
            enabled = false
        }
        active_opacity = 1.0
        inactive_opacity = 1.0
        fullscreen_opacity = 1.0
    }
    
    # Disable all animations
    animations {
        enabled = false
    }
    
    # Basic input configuration
    input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0
        force_no_accel = true
        numlock_by_default = true
    }
    
    # Disable all effects
    general {
        gaps_in = 0
        gaps_out = 0
        border_size = 1
        col.active_border = rgba(ffffff00)
        col.inactive_border = rgba(59595900)
        layout = dwindle
        allow_tearing = false
    }
    
    # Disable dwindle effects
    dwindle {
        pseudotile = false
        preserve_split = true
        no_gaps_when_only = true
    }
    
    # Basic keybinds
    $mainMod = SUPER
    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, C, killactive
    bind = $mainMod, M, exit
    bind = $mainMod, V, togglefloating
    bind = $mainMod, F, exec, firefox
    bind = $mainMod, RETURN, exec, kitty
    
    # Window management
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d
    
    # Monitor configuration - very basic
    monitor = ,preferred,auto,1
  '';

  # Networking
  networking = {
    hostName = "nixvm-hyprland-noegl";
    networkmanager.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
} 