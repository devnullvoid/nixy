# Hyprland using older version without Aquamarine backend
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

  # Environment variables for legacy wlroots backend
  environment.variables = {
    # Force software rendering
    "WLR_RENDERER" = "pixman";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "LIBGL_ALWAYS_SOFTWARE" = "1";
    "GALLIUM_DRIVER" = "llvmpipe";
    "MESA_LOADER_DRIVER_OVERRIDE" = "swrast";
    
    # Legacy wlroots flags
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_NO_SD_NOTIFY" = "1";
    "WLR_DRM_NO_ATOMIC" = "1";
    "WLR_DRM_NO_MODIFIERS" = "1";
    
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

  # Manual Hyprland service (since we're using old package)
  systemd.user.services.hyprland = {
    description = "Hyprland - A dynamic tiling Wayland compositor";
    documentation = [ "man:Hyprland(1)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${oldPkgs.hyprland}/bin/Hyprland";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

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

  # Create a minimal Hyprland config for stability
  environment.etc."hyprland/hyprland.conf".text = ''
    # Minimal Hyprland config for stability (pre-Aquamarine)
    
    # Disable all effects and animations
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        vfr = false
        vrr = 0
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
  '';

  # Networking
  networking = {
    hostName = "nixvm-hyprland-old";
    networkmanager.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
} 