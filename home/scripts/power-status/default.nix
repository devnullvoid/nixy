# Power status and management scripts
{ pkgs, ... }:
let
  power-status = pkgs.writeShellScriptBin "power-status" ''
    echo "=== Power Status ==="
    
    # Check AC power
    ac_connected=false
    if [ -d "/sys/class/power_supply" ]; then
      for ps in /sys/class/power_supply/A{C,DP}*; do
        if [ -f "$ps/online" ]; then
          online=$(cat "$ps/online" 2>/dev/null || echo "0")
          if [ "$online" = "1" ]; then
            echo "AC Power: Connected"
            ac_connected=true
            break
          fi
        fi
      done
    fi
    
    if [ "$ac_connected" = "false" ]; then
      echo "AC Power: Disconnected (On Battery)"
    fi
    
    # Check battery status
    if [ -f "/sys/class/power_supply/BAT0/capacity" ]; then
      battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
      battery_status=$(cat /sys/class/power_supply/BAT0/status)
      echo "Battery: $battery_level% ($battery_status)"
    fi
    
    # Check current power profile
    if command -v powerprofilesctl &> /dev/null; then
      current_profile=$(powerprofilesctl get)
      echo "Power Profile: $current_profile"
    fi
    
    # Check CPU governor
    if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" ]; then
      governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
      echo "CPU Governor: $governor"
    fi
    
    # Check hypridle status
    if pgrep hypridle > /dev/null; then
      echo "Hypridle: Running"
    else
      echo "Hypridle: Not running"
    fi
  '';

  test-smart-suspend = pkgs.writeShellScriptBin "test-smart-suspend" ''
    echo "Testing smart suspend logic..."
    
    # Check if we're on AC power
    if [ -d "/sys/class/power_supply" ]; then
      # Check all power supplies for AC adapters
      for ps in /sys/class/power_supply/A{C,DP}*; do
        if [ -f "$ps/online" ]; then
          online=$(cat "$ps/online" 2>/dev/null || echo "0")
          if [ "$online" = "1" ]; then
            echo "AC power detected - suspend would be SKIPPED"
            exit 0
          fi
        fi
      done
    fi
    
    echo "On battery power - suspend would be TRIGGERED"
    echo "Run with '--execute' to actually suspend"
    
    if [ "$1" = "--execute" ]; then
      echo "Executing suspend in 5 seconds... (Ctrl+C to cancel)"
      sleep 5
      systemctl suspend
    fi
  '';

  toggle-power-profile = pkgs.writeShellScriptBin "toggle-power-profile" ''
    if ! command -v powerprofilesctl &> /dev/null; then
      echo "powerprofilesctl not found"
      exit 1
    fi
    
    current=$(powerprofilesctl get)
    
    case "$current" in
      "power-saver")
        powerprofilesctl set balanced
        echo "Switched to: balanced"
        ;;
      "balanced")
        powerprofilesctl set performance
        echo "Switched to: performance"
        ;;
      "performance")
        powerprofilesctl set power-saver
        echo "Switched to: power-saver"
        ;;
      *)
        echo "Unknown profile: $current"
        ;;
    esac
  '';

in {
  home.packages = [ power-status test-smart-suspend toggle-power-profile ];
} 