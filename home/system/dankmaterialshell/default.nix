{ lib, ... }:
{
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
  };

  # Prevent home-manager from symlinking settings.json to the nix store
  # so DMS can write to it directly from its settings GUI
  xdg.configFile."DankMaterialShell/settings.json".enable = lib.mkForce false;
}
