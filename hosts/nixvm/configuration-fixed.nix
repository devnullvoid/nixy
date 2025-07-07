# Fixed nixvm configuration - don't disable essential services
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
    ../../nixos/hyprland.nix
    
    # VM-specific: Skip hardware-specific modules
    # ../../nixos/bluetooth.nix  # Not needed in VM
    # ../../nixos/tailscale.nix  # Skip for lean VM
    # ../../nixos/nix-ld.nix     # Skip for lean VM
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