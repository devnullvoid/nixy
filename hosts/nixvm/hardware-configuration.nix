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

  # Generic filesystem configuration - adjust as needed
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";  # Adjust based on your VM setup
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";  # Adjust based on your VM setup  
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # Add swap to prevent OOM during builds
  swapDevices = [{
    device = "/swapfile";
    size = 4096; # 4GB swap - increase if you have more disk space
  }];

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