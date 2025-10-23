# DankMaterialShell Migration Plan for Procyon Host

## Overview
Switching from hyprpanel to DankMaterialShell on the "procyon" host (Dell Latitude 5520 running Hyprland).

## Current Setup Analysis

### Flake Configuration
- **Location**: `nixy/flake.nix`
- **Status**: ✅ DankMaterialShell inputs already configured
- **Inputs Present**:
  - `dgop` (system monitoring)
  - `dms-cli` (CLI tools)
  - `dankMaterialShell` (main shell)

### Procyon Configuration
- **Host Config**: `nixy/hosts/procyon/configuration.nix`
- **Home Config**: `nixy/hosts/procyon/home.nix`
- **Variables**: `nixy/hosts/procyon/variables.nix`
  - Location: Annapolis
  - Timezone: America/New_York
  - Keyboard: US layout
  - Username: jon

### Current Imports in home.nix
- Already importing: `inputs.dankMaterialShell.homeModules.dankMaterialShell.default`
- Currently using: `../../home/system/hyprpanel`
- Using: Hyprland (not Niri)

## Migration Steps

### Step 1: Create DankMaterialShell Configuration
**File to create**: `nixy/home/system/dankmaterialshell/default.nix`

**Configuration options to enable**:
```nix
programs.dankMaterialShell = {
  enable = true;
  enableSystemd = true;  # Auto-start with systemd
  
  # Optional features (recommended)
  enableSystemMonitoring = true;      # Requires dgop - CPU/RAM/GPU monitoring
  enableClipboard = true;              # Clipboard history with cliphist
  enableVPN = true;                    # VPN widget support
  enableBrightnessControl = true;      # Backlight control
  enableColorPicker = true;            # Color picker support
  enableDynamicTheming = true;         # Matugen theming from wallpaper
  enableAudioWavelength = true;        # Audio visualizer (cava)
  enableCalendarEvents = true;         # Calendar integration (khal)
  enableSystemSound = true;            # System sounds
  
  # Optional: Configure default settings
  default.settings = {
    # Custom settings here if needed
  };
};
Step 2: Update Hyprland Exec-Once
File to modify: nixy/home/system/hyprland/default.nix
Current:
exec-once = [
  "dbus-update-activation-environment --systemd --all &"
  "systemctl --user enable --now hyprpaper.service &"
  "systemctl --user enable --now hypridle.service &"
];
Change to:
exec-once = [
  "dbus-update-activation-environment --systemd --all &"
  "systemctl --user enable --now hyprpaper.service &"
  "systemctl --user enable --now hypridle.service &"
  "bash -c \"wl-paste --watch cliphist store &\""  # Clipboard history
  "dms run"  # Start DankMaterialShell
];
Step 3: Update Hyprland Keybindings
File to modify: nixy/home/system/hyprland/bindings.nix
Replace these bindings:
# OLD hyprpanel/wofi bindings to REPLACE:
"$mod,X, exec, powermenu"              # Replace with DMS power menu
"$mod,SPACE, exec, menu"               # Replace with DMS spotlight
"$mod,C, exec, quickmenu"              # Replace with DMS control center
"$shiftMod,T, exec, hyprpanel-toggle"  # Can remove (no direct equivalent)
"$shiftMod,C, exec, clipboard"         # Replace with DMS clipboard
"$mod,L, exec, ${pkgs.hyprlock}/bin/hyprlock"  # Replace with DMS lock
NEW DankMaterialShell bindings:
bind = [
  # Core DMS bindings
  "$mod,SPACE, exec, dms ipc call spotlight toggle"         # Application launcher
  "$mod,C, exec, dms ipc call control-center toggle"        # Control center
  "$mod,X, exec, dms ipc call powermenu toggle"             # Power menu
  "$shiftMod,C, exec, dms ipc call clipboard toggle"        # Clipboard manager
  "$mod,V, exec, dms ipc call clipboard toggle"             # Alt clipboard binding
  "$mod,M, exec, dms ipc call processlist toggle"           # Task manager
  "$mod,N, exec, dms ipc call notifications toggle"         # Notification center
  "$mod,comma, exec, dms ipc call settings toggle"          # DMS settings
  "$mod,P, exec, dms ipc call notepad toggle"               # Notepad
  "SUPERALT,L, exec, dms ipc call lock lock"                # Lock screen
  "$mod,Y, exec, dms ipc call dankdash wallpaper"           # Wallpaper browser
  "$mod,TAB, exec, dms ipc call hypr toggleOverview"        # Hyprland overview
  "$shiftMod,N, exec, dms ipc call night toggle"            # Night mode toggle
  
  # Keep existing bindings
  "$mod,RETURN, exec, ${pkgs.kitty}/bin/kitty"
  "$mod,E, exec, ${pkgs.xfce.thunar}/bin/thunar"
  "$mod,B, exec, zen-beta"
  "$mod,K, exec, ${pkgs.bitwarden}/bin/bitwarden"
  "$mod,Q, killactive,"
  "$mod,T, togglefloating,"
  "$mod,F, fullscreen"
  # ... (all other existing bindings remain)
];

# Update audio/brightness bindings to use DMS
bindl = [
  ",XF86AudioMute, exec, dms ipc call audio mute"
  ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
  ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
  ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
  ",switch:Lid Switch, exec, dms ipc call lock lock"
];

bindle = [
  ",XF86AudioRaiseVolume, exec, dms ipc call audio increment 3"
  ",XF86AudioLowerVolume, exec, dms ipc call audio decrement 3"
  ",XF86MonBrightnessUp, exec, dms ipc call brightness increment 5 \"\""
  ",XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5 \"\""
];
Step 4: Update home.nix Imports
File to modify: nixy/hosts/procyon/home.nix
Change:
# Comment out or remove:
# ../../home/system/hyprpanel

# Add:
../../home/system/dankmaterialshell
Step 5: Remove/Disable Conflicting Services
Files/imports that may conflict and should be reviewed:
../../home/system/wofi - DMS has built-in launcher (may want to keep for fallback)
../../home/system/clipman - DMS handles clipboard (should disable)
Post-Migration Checklist
Configuration Files Generated by DMS
DMS will auto-generate these files:
~/.config/DankMaterialShell/settings.json - Main settings
~/.config/DankMaterialShell/session.json - Session data
~/.config/gtk-3.0/dank-colors.css - GTK theming (if enabled)
~/.config/gtk-4.0/dank-colors.css - GTK4 theming (if enabled)
~/.config/qt6ct/colors/matugen.conf - QT theming (if enabled)
Profile Picture
DMS will look for ~/.face.icon for dashboard avatar (already configured in procyon).
Optional Integrations
Terminal theming (if using Ghostty or Kitty):
# Ghostty
echo "config-file = ./config-dankcolors" >> ~/.config/ghostty/config

# Kitty
echo "include dank-theme.conf" >> ~/.config/kitty/kitty.conf
GTK Theme (requires adw-gtk-theme): Enable in DMS Settings → Theme & Colors → “Apply GTK themes”
QT Theme (requires qt6ct-kde):
env = [
  "QT_QPA_PLATFORMTHEME,qt6ct"
  "QT_QPA_PLATFORMTHEME_QT6,qt6ct"
];
Testing Strategy
Build without switching: nixos-rebuild build --flake .#procyon
Check for errors: Review build output
Switch: sudo nixos-rebuild switch --flake .#procyon
Re-login: Log out and back in to start DMS
Verify: Test keybindings and features
Rollback Plan
If issues occur, revert by:
Uncomment hyprpanel import in home.nix
Comment out dankmaterialshell import
Revert hyprland bindings changes
Rebuild: sudo nixos-rebuild switch --flake .#procyon
Feature Comparison
What You Keep
✅ System tray
✅ Clock/date widget
✅ Battery/power monitoring
✅ Network/WiFi control
✅ Bluetooth control
✅ Volume control
✅ Workspace switcher
✅ Media player controls
✅ Notification center
✅ Weather widget
✅ Dynamic theming
What You Gain
✅ Built-in lock screen (can replace hyprlock)
✅ Task manager/process list with dgop
✅ Notepad/scratchpad
✅ Clipboard history viewer with images
✅ Unified control center
✅ Wallpaper browser
✅ Calendar integration (with vdirsyncer/khal)
✅ Dock (optional)
✅ Idle management (can replace hypridle)
✅ Night mode automation
What Changes
🔄 Different visual style (Material Design 3)
🔄 Different settings interface (built-in modal vs hyprpanel)
🔄 IPC-based control system
Known Considerations
Theming: DMS uses Material Design 3 vs hyprpanel’s custom theme
Niri optimized: DMS is optimized for Niri but works with Hyprland
Resource usage: May be different from hyprpanel (monitor with dgop)
Customization: Different plugin system than hyprpanel
References
DMS GitHub: https://github.com/AvengeMedia/DankMaterialShell
DMS IPC Docs: docs/IPC.md in repo
DMS Plugins: PLUGINS/ directory for examples
Custom Themes: docs/CUSTOM_THEMES.md

DMS Nix Module: https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/nix/default.nix