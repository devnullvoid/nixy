# Enhanced VirtIO-GPU Wayland configuration for Hyprland
{ config, pkgs, lib, ... }: {
  imports = [
    # Basic system configuration
    # ../../nixos/audio.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ./bootloader.nix  # VM-specific bootloader (GRUB for MBR)
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    ../../nixos/sddm.nix
    ../../nixos/ssh.nix

    # VM optimizations - but don't disable essential services
    ./vm-optimizations-safe.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  # Enhanced VirtIO-GPU configuration for Wayland
  boot = {
    # VirtIO-GPU kernel modules with enhanced parameters
    kernelModules = [
      "virtio_gpu"
      "virtio_pci"
      "virtio_balloon"
      "virtio_rng"
      "virtio_console"
      "drm"
      "drm_kms_helper"
    ];
    
    # Enhanced VirtIO-GPU kernel parameters for Wayland
    kernelParams = [
      # Force VirtIO-GPU probe
      "virtio_gpu.force_probe=1"
      # Enable VirtIO-GPU features
      "virtio_gpu.modeset=1"
      # DRM debugging (can be removed later)
      "drm.debug=0x04"
      # Disable fbcon for better Wayland performance
      "fbcon=off"
      # Force DRM card detection
      "drm.force_probe=virtio_gpu"
    ];
    
    # Enable early KMS for VirtIO-GPU
    initrd.kernelModules = [ "virtio_gpu" "drm" ];
    
    # Ensure proper module loading order
    extraModprobeConfig = ''
      options virtio_gpu modeset=1
      options drm_kms_helper poll=0
    '';
  };

  # Enhanced hardware graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    
    extraPackages = with pkgs; [
      # Enhanced VirtIO-GPU drivers
      mesa
      # VirtGL for 3D acceleration
      virglrenderer
      # Wayland-specific packages
      libva
      libva-utils
      # Additional DRM support
      libdrm
      # Vulkan support (experimental)
      vulkan-loader
      vulkan-validation-layers
      # Additional Mesa drivers
      mesa-demos
      # SPICE graphics support
      spice-gtk
      # Wayland protocols
      wayland
      wayland-protocols
      wayland-utils
    ];
  };

  # Enhanced environment variables for VirtIO-GPU Wayland
  environment.variables = {
    # VirtIO-GPU specific
    "MESA_LOADER_DRIVER_OVERRIDE" = "virgl";
    "GALLIUM_DRIVER" = "virpipe";
    "LIBGL_ALWAYS_SOFTWARE" = "0";  # Try hardware first
    
    # Wayland-specific
    "WAYLAND_DISPLAY" = "wayland-0";
    "XDG_SESSION_TYPE" = "wayland";
    "XDG_CURRENT_DESKTOP" = "Hyprland";
    
    # DRM/KMS
    "DRM_RENDER_DEVICE" = "/dev/dri/renderD128";
    "WLR_DRM_DEVICES" = "/dev/dri/card0";
    
    # Hyprland-specific optimizations
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
    "HYPRLAND_LOG_WLR" = "1";
    "HYPRLAND_NO_RT" = "1";  # Disable realtime scheduling
    
    # Additional debugging (can be removed later)
    "WAYLAND_DEBUG" = "1";
    "LIBGL_DEBUG" = "verbose";
  };

  # Enhanced services for VirtIO-GPU
  services = {
    # SPICE guest agent for better VM integration
    spice-vdagentd.enable = true;
    
    # QEMU guest agent
    qemuGuest.enable = true;
    
    # Disable unnecessary services that might conflict
    xserver.enable = lib.mkForce false;  # Ensure no X11 conflicts
  };

  # Enhanced systemd services for VirtIO-GPU
  systemd.services = {
    # Ensure proper DRM device permissions
    "virtio-gpu-setup" = {
      description = "Setup VirtIO-GPU for Wayland";
      wantedBy = [ "multi-user.target" ];
      before = [ "display-manager.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "virtio-gpu-setup" ''
          # Ensure proper permissions on DRM devices
          chmod 666 /dev/dri/card* 2>/dev/null || true
          chmod 666 /dev/dri/renderD* 2>/dev/null || true
          
          # Load VirtIO-GPU module if not loaded
          modprobe virtio_gpu 2>/dev/null || true
          
          # Set up environment for Wayland
          mkdir -p /run/user/1000
          chown jon:users /run/user/1000
          chmod 700 /run/user/1000
        '';
      };
    };
  };

  # Enhanced udev rules for VirtIO-GPU
  services.udev.extraRules = ''
    # VirtIO-GPU device permissions
    SUBSYSTEM=="drm", KERNEL=="card*", GROUP="video", MODE="0666"
    SUBSYSTEM=="drm", KERNEL=="renderD*", GROUP="render", MODE="0666"
    SUBSYSTEM=="drm", KERNEL=="controlD*", GROUP="video", MODE="0666"
    
    # VirtIO-GPU specific rules
    SUBSYSTEM=="pci", ATTR{vendor}=="0x1af4", ATTR{device}=="0x1050", TAG+="seat", TAG+="master-of-seat"
  '';

  # Ensure user has proper groups
  users.users.jon.extraGroups = [ "video" "render" "input" "kvm" ];

  # Enhanced security settings for VM
  security = {
    # Allow Wayland compositors to access DRM
    wrappers = {};
    
    # Enhanced polkit rules for VirtIO-GPU
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id.indexOf("org.freedesktop.login1.") == 0 && subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };

  # Home manager configuration
  home-manager.users."${config.var.username}" = import ./home.nix;

  # Additional system packages for debugging
  environment.systemPackages = with pkgs; [
    # VirtIO-GPU debugging tools
    pciutils
    lshw
    glxinfo
    mesa-demos
    vulkan-tools
    # Wayland debugging tools
    wayland-utils
    wlr-randr
    # DRM debugging
    libdrm
    # Additional debugging
    strace
    ltrace
  ];

  # Don't touch this
  system.stateVersion = "25.05";
} 