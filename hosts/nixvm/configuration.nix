{ config, pkgs, ... }: {
  imports = [
    # Only essential system configuration
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ./bootloader.nix  # VM-specific bootloader (GRUB for MBR)
    ../../nixos/sddm.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ./hyprland-nixpkgs.nix  # VM-specific Hyprland using nixpkgs
    ../../nixos/ssh.nix

    # VM optimizations
    ./vm-optimizations.nix

    # Removed heavy modules for minimal VM:
    # ../../nixos/fonts.nix         # HEAVY: Multiple nerd fonts, CJK fonts (~3GB)
    # ../../nixos/nix-ld.nix        # Not essential for basic testing
    # ../../nixos/audio.nix         # No audio needed in VM
    # ../../nixos/bluetooth.nix     # No bluetooth in VM
    # ../../nixos/tailscale.nix     # VPN not needed for testing

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Minimal font setup instead of full fonts.nix
  fonts = {
    packages = with pkgs; [
      dejavu_fonts           # Basic system fonts
      noto-fonts-emoji       # Only emoji font (needed for UI)
      nerd-fonts.jetbrains-mono  # Just one nerd font for terminal
    ];
    enableDefaultPackages = false;
  };

  # Essential packages only
  environment.systemPackages = with pkgs; [
    ripgrep  # Essential search tool
    git      # Essential for flake work
    vim      # Basic editor
  ];

  # VM-specific optimizations
  # virtualisation.vmware.guest.enable = true; # Enable if using VMware
  # virtualisation.virtualbox.guest.enable = true; # Enable if using VirtualBox

  # Don't touch this
  system.stateVersion = "25.05";
} 