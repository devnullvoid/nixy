# Minimal Hyprland configuration based on working Sway setup
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

  # VirtIO-GPU kernel configuration (same as working Sway setup)
  boot = {
    kernelModules = [ "virtio_gpu" "drm" "drm_kms_helper" ];
    kernelParams = [
      "virtio_gpu.force_probe=1"
      "virtio_gpu.modeset=1"
    ];
    initrd.kernelModules = [ "virtio_gpu" ];
    
    extraModprobeConfig = ''
      options virtio_gpu modeset=1 force_probe=1
    '';
  };

  # Hardware graphics (same as working Sway setup)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      virglrenderer
      libdrm
    ];
  };

  # Environment variables optimized for VirtIO-GPU + Hyprland
  environment.variables = {
    # VirtIO-GPU settings that work with Sway
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "WLR_DRM_DEVICES" = "/dev/dri/card0";
    "WLR_RENDERER" = "gles2";  # Use same renderer as Sway
    
    # Hyprland-specific optimizations for VM
    "HYPRLAND_NO_RT" = "1";  # Disable realtime scheduling
    "HYPRLAND_NO_SD_NOTIFY" = "1";  # Disable systemd notifications
  };

  # Ensure proper DRM device permissions (same as working setup)
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", GROUP="video", MODE="0666"
    KERNEL=="card*", GROUP="video", MODE="0666"  
    KERNEL=="renderD*", GROUP="render", MODE="0666"
  '';

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  # Simple SDDM configuration (since we know display manager works from X11 test)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Essential packages
  environment.systemPackages = with pkgs; [
    # Terminal for Hyprland
    kitty
    foot
    
    # Basic tools
    firefox
    
    # Debugging tools
    pciutils
    wayland-utils
    wlr-randr
  ];

  # Networking
  networking = {
    hostName = "nixvm-hyprland";
    networkmanager.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
} 