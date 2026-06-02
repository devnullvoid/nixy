{
  pkgs,
  lib,
  config,
  ...
}: let
  accent = config.theme.accent;
  base00 = config.lib.stylix.colors.base00;
  base01 = config.lib.stylix.colors.base01;
  base02 = config.lib.stylix.colors.base02;
  base05 = config.lib.stylix.colors.base05;
  gaps = toString config.theme.gaps-in;
in {
  home.packages = lib.mkAfter [
    pkgs.niri
    pkgs.wlr-randr
    pkgs.xwayland-satellite
    pkgs.swayidle
    pkgs.wl-clipboard
    pkgs.cliphist
  ];

  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
    spawn-at-startup "swayidle" "-w" "timeout" "180" "niri msg action power-off-monitors" "resume" "niri msg action power-on-monitors"
    spawn-at-startup "copyq" "--start-server"

    workspace "home"
    workspace "code"
    workspace "misc"

    prefer-no-csd

    environment {
        DISPLAY ":0"
        CLUTTER_BACKEND "wayland"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        GDK_BACKEND "wayland,x11"
        _JAVA_AWT_WM_NONREPARENTING "1"
        MOZ_ENABLE_WAYLAND "1"
        NIXOS_OZONE_WL "1"
        OZONE_PLATFORM "wayland"
        QT_QPA_PLATFORM "wayland;xcb"
        QT_QPA_PLATFORMTHEME "qt6ct"
        QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
        SDL_VIDEODRIVER "wayland"
    }

    hotkey-overlay {
        skip-at-startup
    }

    cursor {
        xcursor-theme "Bibata-Mocha"
        xcursor-size 28
        hide-after-inactive-ms 5000
    }

    input {
        keyboard {
            xkb {
                layout "us"
            }
            repeat-delay 400
            repeat-rate 25
            track-layout "global"
            numlock
        }

        touchpad {
            dwt
            dwtp
            accel-speed 0.2
            accel-profile "adaptive"
            scroll-method "two-finger"
            natural-scroll
            click-method "clickfinger"
            middle-emulation
        }

        mouse {
            accel-profile "flat"
            middle-emulation
        }
    }

    output "eDP-1" {
        scale 1
        transform "normal"
        position x=0 y=0
    }

    overview {
        backdrop-color "#${base00}"
        workspace-shadow {
            off
        }
    }

    layout {
        gaps ${gaps}
        background-color "transparent"
        center-focused-column "never"
        always-center-single-column

        preset-column-widths {
            proportion 0.25
            proportion 0.5
            proportion 0.75
            proportion 0.99
        }

        preset-window-heights {
            proportion 0.25
            proportion 0.5
            proportion 0.75
            proportion 1.0
        }

        default-column-width {}

        focus-ring {
            off
        }

        border {
            width 2
            active-color "#${accent}"
            inactive-color "#${base02}"
            urgent-color "#f38ba8"
        }

        shadow {
            on
            softness 6
            spread 2
            offset x=0 y=0
            draw-behind-window false
            color "#${accent}7f"
            inactive-color "#${base00}"
        }

        insert-hint {
            color "#f5c2e759"
        }
    }

    blur {
        passes 2
        offset 5
        noise 0.02
        saturation 1.5
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    animations {
        slowdown 1.25
        workspace-switch {
            spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
        }
        overview-open-close {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        horizontal-view-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        window-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        window-resize {
            spring damping-ratio=0.4 epsilon=0.0001 stiffness=400
        }
        window-open {
            duration-ms 400
            curve "ease-out-quad"
        }
        window-close {
            duration-ms 400
            curve "ease-out-quad"
        }
    }

    layer-rule {
        match namespace="^swww-daemon$"
        place-within-backdrop true
    }
    layer-rule {
        match namespace="^quickshell$"
        place-within-backdrop true
    }
    layer-rule {
        match namespace="dms:blurwallpaper"
        place-within-backdrop true
    }
    layer-rule {
        match namespace="waybar"
        match at-startup=true
        shadow {
            on
            softness 40
            spread 5
            offset x=0 y=0
            draw-behind-window false
            color "#${base00}f0"
        }
        geometry-corner-radius 10
        place-within-backdrop true
    }
    layer-rule {
        match namespace="walker"
        match namespace="wofi"
        match namespace="rofi"
        match namespace="anyrun"
        match namespace="launcher"
        match namespace="fuzzel"
        match namespace="niriswitcher"
        shadow {
            on
            softness 40
            spread 5
            offset x=1 y=1
            draw-behind-window false
            color "#${base00}f0"
        }
        opacity 0.9
    }

    switch-events {
        lid-close { spawn "hyprlock"; }
    }

    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
        opacity 0.95
        draw-border-with-background false
        background-effect {
            blur true
        }
    }

    window-rule {
        match app-id="com.github.hluk.copyq"
        open-floating true
    }

    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        match app-id=r#"firefox$"# title="^Library$"
        match app-id=r#"mpv$"#
        match app-id=r#"waypaper$"#
        open-floating true
        opacity 1.0
    }

    window-rule {
        match app-id=r#"firefox$"#
        match app-id=r#"chromium$"#
        match app-id=r#"vivaldi-stable$"#
        match app-id=r#"virt-manager$"#
        open-on-workspace "misc"
        opacity 1.0
    }

    window-rule {
        match app-id=r#"cursor$"#
        match app-id=r#"windsurf$"#
        match app-id=r#"dev.zed.Zed$"#
        match app-id=r#"code$"#
        match app-id=r#"kiro"#
        open-on-workspace "code"
    }

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }
        Mod+Return { spawn "kitty"; }
        Mod+Q { close-window; }
        Mod+F { spawn "firefox"; }
        Mod+E { spawn "kitty" "-e" "yazi"; }
        Mod+Space { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
        Ctrl+grave { spawn "copyq" "toggle"; }

        Mod+Tab repeat=false { toggle-overview; }

        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Alt+Down  { focus-window-down; }
        Mod+Alt+Up    { focus-window-up; }
        Mod+H     { focus-column-left; }
        Mod+L     { focus-column-right; }
        Mod+Alt+J     { focus-window-down; }
        Mod+Alt+K     { focus-window-up; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+L     { move-column-right; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+K     { move-window-up; }

        Mod+Down { focus-workspace-down; }
        Mod+Up   { focus-workspace-up; }
        Mod+J { focus-workspace-down; }
        Mod+K { focus-workspace-up; }

        Mod+Shift+Down { move-column-to-workspace-down; }
        Mod+Shift+Up   { move-column-to-workspace-up; }
        Mod+Shift+J { move-column-to-workspace-down; }
        Mod+Shift+K { move-column-to-workspace-up; }

        Mod+Shift+Right { consume-window-into-column; }
        Mod+Shift+Left  { expel-window-from-column; }
        Mod+Shift+H { expel-window-from-column; }
        Mod+Shift+L { consume-window-into-column; }

        Mod+Shift+F { fullscreen-window; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Alt+1 { move-window-to-workspace 1; }
        Mod+Alt+2 { move-window-to-workspace 2; }
        Mod+Alt+3 { move-window-to-workspace 3; }
        Mod+Alt+4 { move-window-to-workspace 4; }
        Mod+Alt+5 { move-window-to-workspace 5; }
        Mod+Alt+6 { move-window-to-workspace 6; }
        Mod+Alt+7 { move-window-to-workspace 7; }
        Mod+Alt+8 { move-window-to-workspace 8; }
        Mod+Alt+9 { move-window-to-workspace 9; }

        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+M { maximize-column; }
        Mod+C { center-column; }

        Mod+Minus { set-column-width "-5%"; }
        Mod+Equal { set-column-width "+5%"; }
        Mod+Shift+Minus { set-window-height "-5%"; }
        Mod+Shift+Equal { set-window-height "+5%"; }

        Mod+W       { toggle-window-floating; }
        Mod+Shift+W { switch-focus-between-floating-and-tiling; }
        Mod+Shift+C { center-window; }

        // Media keys
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
        XF86MonBrightnessUp  allow-when-locked=true { spawn "brightnessctl" "s" "5%+"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "s" "5%-"; }

        Print { screenshot show-pointer=false; }
        Alt+Print { screenshot-screen show-pointer=false; }
        Ctrl+Print { screenshot-window; }

        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
        Super+Alt+L { spawn "hyprlock"; }
    }

    include "dms/binds.kdl"
    include "dms/colors.kdl"
    include "dms/cursor.kdl"
    include "dms/layout.kdl"
    include "dms/outputs.kdl"
    include "dms/wpblur.kdl"
    include "dms/alttab.kdl"
    include "dms/windowrules.kdl"
  '';
}
