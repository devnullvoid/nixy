{ ... }:
{
  programs.dankMaterialShell = {
    enable = true;
    systemd.enable = true;
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableVPN = true;
    enableBrightnessControl = true;
    enableColorPicker = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableSystemSound = true;

    default.settings = {};
    default.session = {};
  };
}
