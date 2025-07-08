# Hypridle is a daemon that listens for user activity and runs commands when the user is idle.
{ pkgs, lib, ... }: 
let
  # Smart suspend script that only suspends when on battery power
  smart-suspend = pkgs.writeShellScriptBin "smart-suspend" ''
    # Check if we're on AC power
    if [ -d "/sys/class/power_supply" ]; then
      # Check all power supplies for AC adapters
      for ps in /sys/class/power_supply/A{C,DP}*; do
        if [ -f "$ps/online" ]; then
          online=$(cat "$ps/online" 2>/dev/null || echo "0")
          if [ "$online" = "1" ]; then
            echo "AC power detected, skipping suspend"
            exit 0
          fi
        fi
      done
    fi
    
    # If we get here, we're on battery power - proceed with suspend
    echo "On battery power, suspending..."
    systemctl suspend
  '';
in {
  services.hypridle = {
    enable = true;
    settings = {

      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        }

        {
          timeout = 900;  # 15 minutes - turn off screen
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        {
          timeout = 1200;  # 20 minutes - smart suspend (only on battery)
          on-timeout = "${smart-suspend}/bin/smart-suspend";
        }
      ];
    };
  };
  systemd.user.services.hypridle.Unit.After =
    lib.mkForce "graphical-session.target";
}
