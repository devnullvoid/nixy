# Hyprland using nixpkgs version (legacy wlroots backend) instead of git version
{ config, pkgs, lib, inputs, ... }: {
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

  # Environment variables for legacy wlroots backend
  environment.variables = {
    # Force software rendering (same as before)
    "WLR_RENDERER" = "pixman";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "LIBGL_ALWAYS_SOFTWARE" = "1";
    "GALLIUM_DRIVER" = "llvmpipe";
    "MESA_LOADER_DRIVER_OVERRIDE" = "swrast";
    
    # Force legacy wlroots backend (avoid Aquamarine)
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_NO_SD_NOTIFY" = "1";
    
    # Additional stability flags
    "WLR_DRM_NO_ATOMIC" = "1";  # Disable atomic modesetting
    "WLR_DRM_NO_MODIFIERS" = "1";  # Disable buffer modifiers
    
    # Debug flags
    "HYPRLAND_LOG_WLR" = "1";
    "WAYLAND_DEBUG" = "1";
  };

  # Use NIXPKGS Hyprland instead of git version (no Aquamarine)
  programs.hyprland = {
    enable = true;
    # DON'T specify package - use nixpkgs version
    # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  # Alternative: Enable it manually if the above doesn't work
  environment.systemPackages = with pkgs; [
    # Use nixpkgs Hyprland (legacy wlroots backend)
    hyprland
    
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

  # Create a minimal Hyprland config for stability
  environment.etc."hyprland/hyprland.conf".text = ''
    # Minimal Hyprland config for stability
    
    # Disable all effects and animations
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        vfr = false
        vrr = 0
        no_direct_scanout = true
        cursor_zoom_factor = 1.0
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
    }
    
    # Basic keybinds
    $mainMod = SUPER
    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, C, killactive
    bind = $mainMod, M, exit
    bind = $mainMod, V, togglefloating
    bind = $mainMod, F, exec, firefox
    
    # Monitor configuration
    monitor = ,preferred,auto,1
    
    # Workspace rules
    workspace = 1, monitor:DP-1, default:true
  '';

  # Networking
  networking = {
    hostName = "nixvm-hyprland-legacy";
    networkmanager.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
} 