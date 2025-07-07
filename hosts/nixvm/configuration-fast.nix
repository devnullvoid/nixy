# Fast-building nixvm configuration - uses nixpkgs Hyprland
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
    # ../../nixos/hyprland.nix  # Skip custom Hyprland - use nixpkgs version
    ../../nixos/ssh.nix

    # VM optimizations - but don't disable essential services
    ./vm-optimizations-safe.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  # Use nixpkgs Hyprland instead of git version (much faster build)
  programs.hyprland = {
    enable = true;
    # Don't specify package - use nixpkgs version
    # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  home-manager.users."${config.var.username}" = import ./home-fast.nix;

  # Don't touch this
  system.stateVersion = "25.05";
} 