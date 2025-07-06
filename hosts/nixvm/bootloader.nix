# VM Bootloader Configuration
# Uses GRUB for MBR partitioning (typical in VMs)
{ pkgs, lib, ... }:

{
  boot = {
    bootspec.enable = true;
    loader = {
      grub = {
        enable = true;
        device = "/dev/vda"; # Adjust based on your VM's disk device
        useOSProber = true;
        configurationLimit = 8;
        # Enable GRUB theme for a nicer boot experience
        # theme = pkgs.nixos-grub2-theme;
      };
      # Disable systemd-boot since we're using GRUB
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = lib.mkForce false;
    };
    
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;

    # VM-optimized kernel parameters
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      # VM-specific optimizations
      "mitigations=off"  # Disable security mitigations for better performance
      "noibrs"           # Disable Indirect Branch Restricted Speculation
      "noibpb"           # Disable Indirect Branch Prediction Barrier
      "nopti"            # Disable Page Table Isolation
      "nospectre_v2"     # Disable Spectre v2 mitigations
      "nospectre_v1"     # Disable Spectre v1 mitigations
      "l1tf=off"         # Disable L1TF mitigations
      "nospec_store_bypass_disable"  # Disable speculative store bypass
      "no_stf_barrier"   # Disable STF barrier
      "mds=off"          # Disable MDS mitigations
      "tsx=on"           # Enable TSX
      "tsx_async_abort=off"  # Disable TSX async abort mitigations
      "kvm.ignore_msrs=1"    # Ignore unknown MSRs in KVM
    ];
    
    # Allow some console output for debugging (override the silent boot from systemd-boot.nix)
    consoleLogLevel = lib.mkForce 3;
    initrd.verbose = false;

    # Disable Plymouth for VMs (can cause issues and not needed)
    plymouth.enable = lib.mkForce false;
  };
} 