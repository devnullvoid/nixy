# VirtIO-GPU optimized Hyprland configuration for QEMU
{ inputs, pkgs, lib, ... }: {
  # Enable Hyprland with VirtIO-GPU specific optimizations
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # VirtIO-GPU specific graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # VirtIO-GPU drivers
      mesa
      libva
      libva-utils
      # VirtGL renderer for 3D acceleration
      virglrenderer
      # SPICE graphics support
      spice-gtk
      # Additional OpenGL support
      libGL
      libGLU
    ];
  };

  # VirtIO-GPU specific kernel modules and boot config
  boot = {
    kernelModules = [
      "virtio_gpu"
      "virtio_pci" 
      "virtio_balloon"
      "drm"
      "drm_kms_helper"
    ];
    
    # VirtIO-GPU specific kernel parameters
    kernelParams = [
      "virtio_gpu.force_probe=1"
      "drm.debug=0x0"
    ];
    
    # Enable early KMS for VirtIO-GPU
    initrd.kernelModules = [ "virtio_gpu" ];
  };

  # VirtIO-GPU and SPICE specific environment variables
  environment.sessionVariables = {
    # VirtIO-GPU specific settings
    MESA_LOADER_DRIVER_OVERRIDE = "virgl";
    GALLIUM_DRIVER = "virpipe";
    
    # Force VirtGL rendering
    WLR_RENDERER = "gles2";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    
    # SPICE/VirtIO cursor and input optimizations
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_DRM_NO_ATOMIC = "1";
    
    # Debug logging for troubleshooting
    HYPRLAND_LOG_WLR = "1";
    WLR_DRM_DEVICES = "/dev/dri/card0";
    
    # OpenGL/EGL settings for VirtIO
    EGL_PLATFORM = "drm";
    GBM_BACKEND = "mesa";
    
    # SPICE display settings
    SPICE_DEBUG_LEVEL = "1";
  };

  # Enable VirtIO and SPICE guest services
  services = {
    # SPICE guest agent for clipboard, resolution, etc.
    spice-vdagentd.enable = true;
    
    # QEMU guest agent
    qemuGuest.enable = true;
    
    # Enable udev for device management
    udev.enable = true;
    
    # Enable dbus (required for Wayland)
    dbus.enable = true;
  };

  # VirtIO-GPU specific udev rules
  services.udev.extraRules = ''
    # VirtIO-GPU device permissions
    SUBSYSTEM=="drm", KERNEL=="card*", TAG+="seat", TAG+="master-of-seat"
    SUBSYSTEM=="drm", KERNEL=="renderD*", GROUP="render", MODE="0666"
    
    # VirtIO input devices
    SUBSYSTEM=="input", ATTRS{name}=="virtio_*", TAG+="seat"
  '';

  # Ensure user has proper permissions
  users.users.jon.extraGroups = [ "video" "render" "input" ];

  # VirtIO-GPU specific security and permissions
  security = {
    # Allow access to DRM devices
    wrappers = {};
    # Enable seat switching for VirtIO
    pam.services.hyprlock = {};
  };

  # VirtIO guest optimizations
  virtualisation = {
    # These would be enabled if using NixOS virtualisation module
    # But we'll set them as environment hints instead
  };

  # Add VirtIO-GPU debugging tools
  environment.systemPackages = with pkgs; [
    # Graphics debugging tools
    glxinfo
    vulkan-tools
    mesa-demos
    # VirtIO debugging
    pciutils
    usbutils
    # SPICE tools
    spice-gtk
  ];
} 