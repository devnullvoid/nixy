# VM Hardware Configuration
# This is a generic configuration suitable for VMs
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")  # QEMU/KVM support
  ];

  # VM-appropriate kernel modules
  boot.initrd.availableKernelModules = [ 
    "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"
    "virtio_blk" "virtio_net" "virtio_mmio" "virtio_balloon"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Generic filesystem configuration for MBR partitioning
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";  # Standard NixOS root partition
    fsType = "ext4";
    options = [ "noatime" "nodiratime" ];  # Performance optimizations
  };

  # For MBR systems, /boot is typically just a directory on the root filesystem
  # No separate /boot partition needed unless specifically configured
  
  # Swap is configured in vm-optimizations.nix to avoid duplicates
  swapDevices = [ ];

  # Enable DHCP on all interfaces (typical for VMs)
  networking.useDHCP = lib.mkDefault true;
  
  # VM-appropriate platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
  # VM guest optimizations
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # VM-specific services
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;  # For SPICE clipboard sharing
} 