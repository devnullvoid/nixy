{ config, lib, pkgs, ... }: {
  # VM-specific optimizations to prevent system freezes during builds
  
  # Reduce parallel builds to prevent memory exhaustion
  nix.settings = {
    # Limit parallel builds (default is usually number of CPU cores)
    max-jobs = lib.mkDefault 1;
    # Limit cores per job
    cores = lib.mkDefault 1;
    # Reduce memory usage during builds
    sandbox = true;
    # Keep build logs smaller
    log-lines = lib.mkDefault 100;
    # Reduce substituter timeout
    connect-timeout = lib.mkDefault 5;
    # Enable more aggressive garbage collection
    min-free = lib.mkDefault (1024 * 1024 * 1024); # 1GB
    max-free = lib.mkDefault (2 * 1024 * 1024 * 1024); # 2GB
  };

  # Add swap to prevent OOM kills
  swapDevices = [{
    device = "/swapfile";
    size = 2048; # 2GB swap file
  }];

  # Optimize systemd for VMs
  systemd.services = {
    # Reduce journal size to prevent disk space issues
    systemd-journald.serviceConfig = {
      SystemMaxUse = "100M";
      RuntimeMaxUse = "100M";
      SystemMaxFileSize = "10M";
      RuntimeMaxFileSize = "10M";
      MaxRetentionSec = "1week";
    };
    
    # Prevent NetworkManager from hanging during boot (override utils.nix)
    NetworkManager-wait-online.enable = lib.mkForce false;
  };

  # Optimize boot parameters for VMs
  boot = {
    # Reduce boot timeout
    loader.timeout = lib.mkDefault 3;
    
    # VM-friendly kernel parameters
    kernelParams = [
      # Reduce memory pressure
      "vm.swappiness=10"
      "vm.vfs_cache_pressure=50"
      # Faster boot
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      # Disable unnecessary features for VMs
      "nopti"
      "nospectre_v2"
      "nospectre_v1"
      "l1tf=off"
      "nospec_store_bypass_disable"
      "no_stf_barrier"
      "mds=off"
      "tsx=on"
      "tsx_async_abort=off"
      "mitigations=off"
    ];
    
    # Disable initrd compression to speed up boot
    initrd.compressor = "gzip";
    initrd.compressorArgs = [ "-1" ]; # Fastest compression
    
    # Reduce kernel log level
    consoleLogLevel = 3;
  };

  # Optimize filesystem for VMs
  fileSystems = {
    "/" = {
      options = [ "noatime" "nodiratime" ];
    };
    "/boot" = {
      options = [ "noatime" ];
    };
  };

  # Reduce systemd service timeouts
  systemd.extraConfig = ''
    DefaultTimeoutStartSec=30s
    DefaultTimeoutStopSec=10s
  '';

  # Optimize memory management
  boot.kernel.sysctl = {
    # Reduce memory pressure
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_expire_centisecs" = 3000;
    "vm.dirty_writeback_centisecs" = 500;
    # Reduce swappiness
    "vm.swappiness" = 10;
    # Optimize for VMs
    "vm.vfs_cache_pressure" = 50;
    "vm.overcommit_memory" = 1;
  };

  # Disable unnecessary services for VMs (override utils.nix)
  services = {
    # Disable power management (not needed in VMs)
    power-profiles-daemon.enable = lib.mkForce false;
    upower.enable = lib.mkForce false;
    
    # Disable bluetooth (not available in VMs)
    blueman.enable = lib.mkForce false;
    
    # Optimize systemd-resolved
    resolved = {
      enable = true;
      dnssec = "false"; # Faster DNS resolution
      fallbackDns = [ "8.8.8.8" "1.1.1.1" ];
    };
  };

  # Reduce font cache size
  fonts.fontconfig.cache32Bit = false;

  # Optimize for single-user VM
  security.polkit.enable = lib.mkDefault false;
  
  # Disable unnecessary documentation for VMs (override utils.nix)
  documentation = {
    enable = lib.mkForce false;
    nixos.enable = lib.mkForce false;
    man.enable = lib.mkForce false;
    info.enable = lib.mkForce false;
    doc.enable = lib.mkForce false;
  };

  # Reduce environment packages
  environment.systemPackages = lib.mkForce (with pkgs; [
    # Only essential packages
    vim
    git
    curl
    wget
    htop
  ]);
} 