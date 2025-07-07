# Minimal Wayland debugging configuration for VirtIO-GPU
{ config, pkgs, lib, ... }: {
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

  # Essential packages for debugging
  environment.systemPackages = with pkgs; [
    # DRM/Graphics debugging
    pciutils
    lshw
    usbutils
    libdrm
    mesa-demos
    glxinfo
    vulkan-tools
    
    # Wayland debugging
    wayland-utils
    wlr-randr
    
    # Basic Wayland compositor for testing
    sway
    
    # Terminal for testing
    foot
    
    # Debugging tools
    strace
    ltrace
    util-linux  # includes dmesg
    lsof
  ];

  # VirtIO-GPU kernel configuration
  boot = {
    kernelModules = [ "virtio_gpu" "drm" "drm_kms_helper" ];
    kernelParams = [
      "virtio_gpu.force_probe=1"
      "virtio_gpu.modeset=1"
      "drm.debug=0x1ff"  # Full DRM debugging
      "log_level=7"      # Verbose kernel logging
    ];
    initrd.kernelModules = [ "virtio_gpu" ];
    
    extraModprobeConfig = ''
      options virtio_gpu modeset=1 force_probe=1
      options drm debug=0x1ff
    '';
  };

  # Hardware graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      virglrenderer
      libdrm
    ];
  };

  # Critical environment variables
  environment.variables = {
    # Force software rendering if hardware fails
    "LIBGL_ALWAYS_SOFTWARE" = "0";
    "WLR_RENDERER" = "gles2";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "WLR_DRM_DEVICES" = "/dev/dri/card0";
    
    # Debugging
    "WAYLAND_DEBUG" = "1";
    "WLR_DRM_DEBUG" = "1";
    "MESA_DEBUG" = "1";
    "LIBGL_DEBUG" = "verbose";
  };

  # Ensure proper DRM device permissions
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", GROUP="video", MODE="0666"
    KERNEL=="card*", GROUP="video", MODE="0666"  
    KERNEL=="renderD*", GROUP="render", MODE="0666"
  '';

  # Custom script to check VirtIO-GPU status
  systemd.services.virtio-gpu-debug = {
    description = "VirtIO-GPU Debug Information";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "virtio-gpu-debug" ''
        echo "=== VirtIO-GPU Debug Information ===" > /var/log/virtio-gpu-debug.log
        echo "Date: $(date)" >> /var/log/virtio-gpu-debug.log
        echo "" >> /var/log/virtio-gpu-debug.log
        
        echo "PCI Devices:" >> /var/log/virtio-gpu-debug.log
        lspci | grep -i vga >> /var/log/virtio-gpu-debug.log || echo "No VGA devices found" >> /var/log/virtio-gpu-debug.log
        lspci | grep -i virtio >> /var/log/virtio-gpu-debug.log || echo "No VirtIO devices found" >> /var/log/virtio-gpu-debug.log
        echo "" >> /var/log/virtio-gpu-debug.log
        
        echo "DRM Devices:" >> /var/log/virtio-gpu-debug.log
        ls -la /dev/dri/ >> /var/log/virtio-gpu-debug.log 2>&1 || echo "No DRI devices found" >> /var/log/virtio-gpu-debug.log
        echo "" >> /var/log/virtio-gpu-debug.log
        
        echo "Loaded Modules:" >> /var/log/virtio-gpu-debug.log
        lsmod | grep -E "(virtio|drm)" >> /var/log/virtio-gpu-debug.log || echo "No relevant modules loaded" >> /var/log/virtio-gpu-debug.log
        echo "" >> /var/log/virtio-gpu-debug.log
        
        echo "Kernel Messages (last 50 lines):" >> /var/log/virtio-gpu-debug.log
        dmesg | tail -50 >> /var/log/virtio-gpu-debug.log
        
        # Set permissions
        chmod 644 /var/log/virtio-gpu-debug.log
      '';
    };
  };

  # Enable SSH for remote debugging
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Networking
  networking = {
    hostName = "nixvm-debug";
    networkmanager.enable = true;
  };

  system.stateVersion = "25.05";
} 