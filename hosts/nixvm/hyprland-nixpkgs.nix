# VM-specific Hyprland configuration using nixpkgs instead of building from source
# This is much faster for VM testing while maintaining flake compatibility
{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # Use nixpkgs version instead of building from source for faster builds
    package = pkgs.hyprland;
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