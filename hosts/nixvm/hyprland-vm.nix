# VM-optimized Hyprland configuration
{ inputs, pkgs, lib, ... }: {
  # Enable Hyprland with VM-specific optimizations
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # VM Graphics support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # VM graphics drivers
      mesa
      libva
      libva-utils
      # QEMU/KVM graphics support
      virglrenderer
      # Additional Mesa drivers for VMs
      mesa.opencl
    ];
  };

  # VM-specific environment variables for Hyprland
  environment.sessionVariables = {
    # Force software rendering if needed
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    # VM-specific Wayland settings
    WLR_NO_HARDWARE_CURSORS = "1";
    # Disable VSync for VMs (can cause issues)
    WLR_DRM_NO_ATOMIC = "1";
    # Enable debug logging
    HYPRLAND_LOG_WLR = "1";
    # Force specific backend
    WLR_BACKENDS = "drm,libinput";
  };

  # Enable necessary services for VM graphics
  services = {
    # Enable udev for device management
    udev.enable = true;
    
    # Enable dbus (required for Wayland)
    dbus.enable = true;
    
    # logind is enabled by default in NixOS
  };

  # VM kernel modules for graphics
  boot.kernelModules = [
    "drm"
    "drm_kms_helper"
    "virtio_gpu"
    "bochs_drm"
    "cirrus"
  ];

  # Ensure user is in video group
  users.users.jon.extraGroups = [ "video" "render" ];

  # VM-specific security settings
  security = {
    # Allow access to DRM devices
    wrappers = {};
    # Enable seat switching
    pam.services.hyprlock = {};
  };
} 