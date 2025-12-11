# Hyprspace is a hyprland plugin that provides a workspaces overview (three-finger swipe up) and a workspace switcher (three-finger down).
{ inputs, pkgs, ... }: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprspace.packages.${system}.Hyprspace
    ];
    settings = {
      plugin = {
        overview = {
          centerAligned = true;
          hideTopLayers = true;
          hideOverlayLayers = true;
          showNewWorkspace = true;
          exitOnClick = true;
          exitOnSwitch = true;
          drawActiveWorkspace = true;
          autoDrag = false;
        };
      };
    };
  };
}
