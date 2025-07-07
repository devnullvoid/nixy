# Minimal configuration with stable Hyprland (pre-Aquamarine)
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
    hostName = "hyprland-test-stable";
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

  # Graphics (24.05 uses hardware.opengl)
  hardware.opengl = {
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
  };

  # Enable Hyprland (stable version)
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

  # Essential services
  services = {
    # SSH for debugging
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
    
    # D-Bus (required for Wayland)
    dbus.enable = true;
    
    # Udev (device management)
    udev.enable = true;
  };

  # Security settings
  security = {
    polkit.enable = true;
    sudo.enable = true;
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

  system.stateVersion = "24.05";
} 