# Hyprland configuration with Aquamarine backend fixes for VirtIO-GPU
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

  # Enhanced VirtIO-GPU kernel configuration for Aquamarine
  boot = {
    kernelModules = [ "virtio_gpu" "drm" "drm_kms_helper" ];
    kernelParams = [
      "virtio_gpu.force_probe=1"
      "virtio_gpu.modeset=1"
      # Force DRM device enumeration
      "drm.force_probe=*"
      # Ensure proper GPU detection
      "video=HDMI-A-1:1024x768@60"
    ];
    initrd.kernelModules = [ "virtio_gpu" ];
    
    extraModprobeConfig = ''
      options virtio_gpu modeset=1 force_probe=1
      options drm force_probe=1
    '';
  };

  # Enhanced hardware graphics for Aquamarine
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      virglrenderer
      libdrm
      # Additional packages for Aquamarine
      libva
      libva-utils
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  # Critical environment variables for Hyprland + Aquamarine + VirtIO-GPU
  environment.variables = {
    # Force Aquamarine to use VirtIO-GPU
    "AQ_DRM_DEVICES" = "/dev/dri/card0";
    "WLR_DRM_DEVICES" = "/dev/dri/card0";
    
    # Force software rendering if GPU detection fails
    "AQ_NO_ATOMIC" = "1";  # Disable atomic modesetting for Aquamarine
    "WLR_RENDERER" = "gles2";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    
    # Hyprland-specific VM optimizations
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_NO_SD_NOTIFY" = "1";
    
    # Force GPU detection
    "LIBGL_ALWAYS_SOFTWARE" = "0";
    "MESA_LOADER_DRIVER_OVERRIDE" = "virgl";
    "GALLIUM_DRIVER" = "virpipe";
    
    # Additional debugging
    "HYPRLAND_LOG_WLR" = "1";
    "AQ_DEBUG" = "1";
  };

  # Enhanced udev rules for VirtIO-GPU detection
  services.udev.extraRules = ''
    # VirtIO-GPU device permissions
    SUBSYSTEM=="drm", GROUP="video", MODE="0666"
    KERNEL=="card*", GROUP="video", MODE="0666", TAG+="seat", TAG+="master-of-seat"
    KERNEL=="renderD*", GROUP="render", MODE="0666"
    KERNEL=="controlD*", GROUP="video", MODE="0666"
    
    # Force VirtIO-GPU as primary GPU
    SUBSYSTEM=="pci", ATTR{vendor}=="0x1af4", ATTR{device}=="0x1050", ENV{ID_PATH_TAG}="virtio-gpu", TAG+="seat", TAG+="master-of-seat"
    
    # Ensure proper device enumeration
    ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card*", RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/dri/card*"
  '';

  # Custom systemd service to ensure VirtIO-GPU is ready
  systemd.services.virtio-gpu-prepare = {
    description = "Prepare VirtIO-GPU for Hyprland";
    wantedBy = [ "multi-user.target" ];
    before = [ "display-manager.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "virtio-gpu-prepare" ''
        # Ensure VirtIO-GPU module is loaded
        modprobe virtio_gpu || true
        
        # Wait for DRM device to appear
        for i in {1..30}; do
          if [ -e /dev/dri/card0 ]; then
            break
          fi
          sleep 1
        done
        
        # Set proper permissions
        chmod 666 /dev/dri/card* 2>/dev/null || true
        chmod 666 /dev/dri/renderD* 2>/dev/null || true
        
        # Create symlink for primary GPU if needed
        if [ ! -e /dev/dri/by-path/pci-0000:00:01.0-card ]; then
          mkdir -p /dev/dri/by-path
          ln -sf /dev/dri/card0 /dev/dri/by-path/pci-0000:00:01.0-card || true
        fi
        
        # Log GPU status
        echo "VirtIO-GPU status:" > /var/log/virtio-gpu-status.log
        lspci | grep -i virtio >> /var/log/virtio-gpu-status.log || true
        ls -la /dev/dri/ >> /var/log/virtio-gpu-status.log || true
      '';
    };
  };

  # Enable Hyprland with specific version
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  # SDDM with Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      General = {
        # Ensure SDDM uses the right session
        DefaultSession = "hyprland.desktop";
      };
    };
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
    mesa-demos
    vulkan-tools
    
    # GPU debugging
    glxinfo
    libdrm
  ];

  # Networking
  networking = {
    hostName = "nixvm-hyprland-fixed";
    networkmanager.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
} 