# Configuration with unstable Hyprland (with Aquamarine)
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
    
    kernelModules = [ "virtio_gpu" "drm" "drm_kms_helper" ];
    kernelParams = [
      "virtio_gpu.force_probe=1"
      "virtio_gpu.modeset=1"
    ];
    initrd.kernelModules = [ "virtio_gpu" ];
  };

  # Basic system
  networking = {
    hostName = "hyprland-test-unstable";
    networkmanager.enable = true;
  };

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.test = {
    isNormalUser = true;
    description = "Test User";
    extraGroups = [ "wheel" "video" "render" "input" ];
    initialPassword = "test";
    shell = pkgs.bash;
  };

  # Graphics (unstable uses hardware.graphics)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      virglrenderer
      libdrm
    ];
  };

  # Environment variables for software rendering
  environment.variables = {
    "WLR_RENDERER" = "pixman";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "LIBGL_ALWAYS_SOFTWARE" = "1";
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_LOG_WLR" = "1";
    # Aquamarine-specific variables
    "AQ_DEBUG" = "1";
    "AQ_NO_ATOMIC" = "1";
  };

  # Enable Hyprland (unstable version with Aquamarine)
  programs.hyprland.enable = true;

  # Basic packages
  environment.systemPackages = with pkgs; [
    kitty
    firefox
    git
    htop
  ];

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # SSH for debugging
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Minimal Hyprland config
  environment.etc."hypr/hyprland.conf".text = ''
    # Minimal Hyprland config
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
    
    monitor = ,preferred,auto,1
  '';

  system.stateVersion = "24.11";
} 