{ config, ... }: {
  imports = [
    # Basic system configuration
    ../../nixos/audio.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    
    # VM-specific: Skip hardware-specific modules
    # ../../nixos/bluetooth.nix  # Not needed in VM
    # ../../nixos/tailscale.nix  # Skip for lean VM
    # ../../nixos/nix-ld.nix     # Skip for lean VM
    ../../nixos/ssh.nix        # Skip for lean VM

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