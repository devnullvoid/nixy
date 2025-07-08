{ config, ... }: {
  imports = [
    # Essential system configuration for flake testing
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ./bootloader.nix  # VM-specific bootloader (GRUB for MBR)
    ../../nixos/sddm.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ./hyprland-nixpkgs.nix  # VM-specific Hyprland using nixpkgs
    ../../nixos/nix-ld.nix
    ../../nixos/ssh.nix

    # VM optimizations
    ./vm-optimizations.nix

    # Removed unnecessary modules for VM:
    # ../../nixos/audio.nix         # No audio needed in VM
    # ../../nixos/bluetooth.nix     # No bluetooth in VM
    # ../../nixos/tailscale.nix     # VPN not needed for testing

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