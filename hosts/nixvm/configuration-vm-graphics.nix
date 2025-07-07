# nixvm configuration with VM-optimized graphics for Hyprland
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
    ./hyprland-vm.nix             # VM-optimized Hyprland instead of standard
    ../../nixos/sddm.nix          # SDDM for GUI login
    ../../nixos/ssh.nix

    # VM optimizations - but don't disable essential services
    ./vm-optimizations-safe.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # VM-specific optimizations
  # virtualisation.vmware.guest.enable = true; # Enable if using VMware
  # virtualisation.virtualbox.guest.enable = true; # Enable if using VirtualBox

  # Don't touch this
  system.stateVersion = "25.05";
} 