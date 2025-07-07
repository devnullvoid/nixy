# nixvm configuration optimized for QEMU VirtIO-GPU with 3D acceleration
{ config, ... }: {
  imports = [
    # Basic system configuration
    # ../../nixos/audio.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ./bootloader.nix  # VM-specific bootloader (GRUB for MBR)
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ./hyprland-virtio.nix         # VirtIO-GPU optimized Hyprland
    ../../nixos/sddm.nix          # SDDM for GUI login
    ../../nixos/ssh.nix

    # VM optimizations - but don't disable essential services
    ./vm-optimizations-safe.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # QEMU/KVM guest optimizations
  virtualisation.vmware.guest.enable = false;
  virtualisation.virtualbox.guest.enable = false;
  # Use QEMU guest agent instead (enabled in hyprland-virtio.nix)

  # Don't touch this
  system.stateVersion = "25.05";
} 