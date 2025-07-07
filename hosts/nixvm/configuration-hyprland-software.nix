# Hyprland with forced software rendering for VirtIO-GPU
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

  # FORCE SOFTWARE RENDERING - Multiple approaches
  environment.variables = {
    # Force Hyprland to use software rendering
    "WLR_RENDERER" = "pixman";  # Force pixman (software) renderer
    "WLR_NO_HARDWARE_CURSORS" = "1";
    
    # Disable all hardware acceleration
    "LIBGL_ALWAYS_SOFTWARE" = "1";
    "GALLIUM_DRIVER" = "llvmpipe";  # Force software rasterizer
    "MESA_LOADER_DRIVER_OVERRIDE" = "swrast";  # Force software rasterizer
    
    # Disable Aquamarine hardware features
    "AQ_NO_ATOMIC" = "1";
    "AQ_NO_MODIFIERS" = "1";
    "AQ_DRM_NO_ATOMIC" = "1";
    
    # Force software rendering for all graphics
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_NO_SD_NOTIFY" = "1";
    
    # Additional software rendering flags
    "MESA_GL_VERSION_OVERRIDE" = "3.3";
    "MESA_GLSL_VERSION_OVERRIDE" = "330";
    "MESA_EXTENSION_OVERRIDE" = "-GL_ARB_get_program_binary";
    
    # Disable hardware video decode
    "LIBVA_DRIVER_NAME" = "dummy";
    
    # Force X11 backend for compatibility (fallback)
    "GDK_BACKEND" = "wayland,x11";
    "QT_QPA_PLATFORM" = "wayland;xcb";
    
    # Debug flags
    "HYPRLAND_LOG_WLR" = "1";
    "WAYLAND_DEBUG" = "1";
    "EGL_LOG_LEVEL" = "debug";
  };

  # Ensure software rendering packages are available
  environment.systemPackages = with pkgs; [
    # Software rendering Mesa
    mesa
    mesa-demos
    
    # Basic terminals that work well with software rendering
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
    
    # Fallback X11 tools in case we need them
    xorg.xrandr
    xorg.xdpyinfo
  ];

  # Enable Hyprland with software rendering optimizations
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  # SDDM with conservative settings
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      General = {
        DefaultSession = "hyprland.desktop";
      };
      Wayland = {
        # Use software rendering for SDDM too
        CompositorCommand = "Hyprland";
      };
    };
  };

  # Create a custom Hyprland config that forces software rendering
  environment.etc."hyprland/hyprland.conf".text = ''
    # Hyprland config optimized for software rendering
    
    # Disable hardware acceleration features
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        vfr = false
        vrr = 0
    }
    
    # Use basic rendering settings
    decoration {
        rounding = 0
        drop_shadow = false
        blur {
            enabled = false
        }
    }
    
    # Disable animations for better software rendering performance
    animations {
        enabled = false
    }
    
    # Basic input configuration
    input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0
    }
    
    # Basic window rules
    windowrule = float, ^(kitty)$
    
    # Basic keybinds
    $mainMod = SUPER
    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, C, killactive
    bind = $mainMod, M, exit
    bind = $mainMod, V, togglefloating
    
    # Basic monitor configuration
    monitor = ,preferred,auto,1
  '';

  # Networking
  networking = {
    hostName = "nixvm-hyprland-software";
    networkmanager.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
} 