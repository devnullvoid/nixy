{ config, lib, pkgs, ... }: {
  # Aggressive VM optimizations to minimize disk usage and memory consumption
  
  # Reduce parallel builds to prevent memory exhaustion
  nix.settings = {
    # Limit parallel builds (default is usually number of CPU cores)
    max-jobs = lib.mkDefault 1;
    # Limit cores per job
    cores = lib.mkDefault 1;
    # Reduce memory usage during builds
    sandbox = true;
    # Keep build logs smaller
    log-lines = lib.mkDefault 50;
    # Reduce substituter timeout
    connect-timeout = lib.mkDefault 5;
    # Enable more aggressive garbage collection
    min-free = lib.mkDefault (512 * 1024 * 1024); # 512MB
    max-free = lib.mkDefault (1024 * 1024 * 1024); # 1GB
    # Additional space-saving settings
    auto-optimise-store = true;
    warn-dirty = false;
  };

  # Minimal swap to prevent OOM kills
  swapDevices = [{
    device = "/swapfile";
    size = 1024; # 1GB swap file (reduced from 2GB)
  }];

  # Optimize systemd for VMs
  systemd.services = {
    # Reduce journal size aggressively
    systemd-journald.serviceConfig = {
      SystemMaxUse = "50M";    # Reduced from 100M
      RuntimeMaxUse = "50M";   # Reduced from 100M
      SystemMaxFileSize = "5M"; # Reduced from 10M
      RuntimeMaxFileSize = "5M"; # Reduced from 10M
      MaxRetentionSec = "3days"; # Reduced from 1week
    };
    
    # Prevent NetworkManager from hanging during boot
    NetworkManager-wait-online.enable = lib.mkForce false;
  };

  # Aggressive boot optimizations
  boot = {
    # Reduce boot timeout
    loader.timeout = lib.mkDefault 1;
    
    # VM-friendly kernel parameters (more aggressive)
    kernelParams = [
      # Reduce memory pressure
      "vm.swappiness=1"        # More aggressive than 10
      "vm.vfs_cache_pressure=200" # More aggressive than 50
      # Faster boot
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      # Disable unnecessary features for VMs
      "nopti" "nospectre_v2" "nospectre_v1" "l1tf=off"
      "nospec_store_bypass_disable" "no_stf_barrier"
      "mds=off" "tsx=on" "tsx_async_abort=off" "mitigations=off"
      # Additional space/performance optimizations
      "quiet" "loglevel=3" "systemd.mask=systemd-gpt-auto-generator"
    ];
    
    # Fastest compression
    initrd.compressor = "gzip";
    initrd.compressorArgs = [ "-1" ];
    
    # Reduce kernel log level
    consoleLogLevel = lib.mkForce 1; # Even more aggressive
  };

  # Optimize filesystem for VMs with aggressive settings
  fileSystems = {
    "/" = {
      options = [ "noatime" "nodiratime" "discard" ]; # Added discard for SSDs
    };
    "/boot" = {
      options = [ "noatime" "discard" ];
    };
  };

  # Aggressive systemd timeouts
  systemd.extraConfig = ''
    DefaultTimeoutStartSec=15s
    DefaultTimeoutStopSec=5s
  '';

  # Aggressive memory management
  boot.kernel.sysctl = {
    # More aggressive memory settings
    "vm.dirty_ratio" = 5;         # Reduced from 15
    "vm.dirty_background_ratio" = 2; # Reduced from 5
    "vm.dirty_expire_centisecs" = 1000; # Reduced from 3000
    "vm.dirty_writeback_centisecs" = 100; # Reduced from 500
    "vm.swappiness" = 1;          # Reduced from 10
    "vm.vfs_cache_pressure" = 200; # Increased from 50
    "vm.overcommit_memory" = 1;
    # Additional optimizations
    "vm.page-cluster" = 0;        # Disable swap readahead
    "vm.laptop_mode" = 1;         # Enable laptop mode for better I/O
  };

  # Disable ALL unnecessary services for minimal VM
  services = {
    # Power management (not needed in VMs)
    power-profiles-daemon.enable = lib.mkForce false;
    upower.enable = lib.mkForce false;
    thermald.enable = lib.mkForce false;
    
    # Hardware services (not available in VMs)
    blueman.enable = lib.mkForce false;
    udisks2.enable = lib.mkForce false;  # Auto-mounting not needed
    
    # Profile sync daemon (saves some space)
    psd.enable = lib.mkForce false;
    
    # Optimize DNS resolution
    resolved = {
      enable = true;
      dnssec = "false";
      fallbackDns = [ "8.8.8.8" "1.1.1.1" ];
    };
  };

  # Disable font cache to save space
  fonts.fontconfig.cache32Bit = false;
  
  # Disable ALL documentation for minimal VM
  documentation = {
    enable = lib.mkForce false;
    nixos.enable = lib.mkForce false;
    man.enable = lib.mkForce false;
    info.enable = lib.mkForce false;
    doc.enable = lib.mkForce false;
    dev.enable = lib.mkForce false;
  };

  # Override environment packages with absolute minimum
  environment.systemPackages = lib.mkForce (with pkgs; [
    # Only the most essential packages
    vim
    git
    curl
  ]);

  # Disable desktop portal extras to save space
  xdg.portal.extraPortals = lib.mkForce [];

  # Minimal hardware enablement
  hardware = {
    enableRedistributableFirmware = lib.mkForce false;
    cpu.intel.updateMicrocode = lib.mkForce false;
    cpu.amd.updateMicrocode = lib.mkForce false;
  };

  # Disable unnecessary networking
  networking = {
    enableIPv6 = false;  # Save some space
    firewall.enable = false; # Not needed in testing VM
  };

  # Minimal systemd services
  systemd.enableEmergencyMode = false;
} 