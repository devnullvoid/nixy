# VM-specific Hyprland configuration using the Hyprland flake input
# Keeps plugin compatibility (Hyprspace) while still applying VM tweaks
{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPkg = inputs.hyprland.packages.${system}.hyprland;
in {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # Use the flake input so Hyprspace matches Hyprland exactly
    package = hyprlandPkg;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  
  # VM-specific environment variables for better compatibility
  environment.variables = {
    # VM-friendly settings that don't break flake features
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "HYPRLAND_NO_RT" = "1";  # Disable realtime scheduling in VMs
    "WLR_DRM_NO_ATOMIC" = "1";  # Better VM compatibility
  };
} 