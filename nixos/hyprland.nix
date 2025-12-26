{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPackage = inputs.hyprland.packages.${system}.hyprland;
in {
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = hyprlandPackage;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  # Required environment variables for Wayland and Hyprland
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    
    # Force Vulkan renderer and disable problematic backends
    WLR_RENDERER = "vulkan";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    
    # Fix for some applications
    _JAVA_AWT_WM_NONREPARENTING = "1";
    
    # Force cursor size to 24, overriding any other settings including Stylix
    XCURSOR_THEME = "breeze_cursors";
    XCURSOR_SIZE = lib.mkForce "24";
  };
  
  # Vulkan configuration is now handled in the hardware.opengl section below
  
  # This ensures our environment variables take precedence over others
  environment.profileRelativeSessionVariables = {
    # Any variables here will be prepended to the existing value with a colon
    # We don't need to add anything here, but this ensures our variables above take precedence
  };

  # Required for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-hyprland
    ];
    xdgOpenUsePortal = true;
  };

  # Configure graphics and hardware acceleration
  hardware.graphics = {
    enable = true;
    
    # Intel media driver and related packages
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      intel-compute-runtime
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
    
    # 32-bit packages
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libvdpau-va-gl
    ];
  };

  # Enable hardware video acceleration
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  # Required for some applications
  services.dbus.enable = true;
  programs.dconf.enable = true;
  
  # Enable necessary systemd services
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.systemPackages = lib.mkAfter [
    pkgs.niri
  ];
}
