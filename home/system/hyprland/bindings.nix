{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        "$mod,RETURN, exec, ${pkgs.kitty}/bin/kitty" # Kitty
        "$mod,E, exec, ${pkgs.xfce.thunar}/bin/thunar" # Thunar
        "$mod,B, exec, zen-beta" # Zen Browser
        "$mod,K, exec, ${pkgs.bitwarden-desktop}/bin/bitwarden" # Bitwarden
        "SUPERALT,L, exec, dms ipc call lock lock" # Lock
        "$mod,SPACE, exec, dms ipc call spotlight toggle"
        "$mod,C, exec, dms ipc call control-center toggle"
        "$mod,X, exec, dms ipc call powermenu toggle"
        "$shiftMod,C, exec, dms ipc call clipboard toggle"
        "$mod,V, exec, dms ipc call clipboard toggle"
        "$mod,M, exec, dms ipc call processlist toggle"
        "$mod,N, exec, dms ipc call notifications toggle"
        "$mod,comma, exec, dms ipc call settings toggle"
        "$mod,P, exec, dms ipc call notepad toggle"
        "$mod,Y, exec, dms ipc call dankdash wallpaper"
        "$mod,TAB, exec, dms ipc call hypr toggleOverview"
        "$shiftMod,N, exec, dms ipc call night toggle"
        "$shiftMod,SPACE, exec, hyprfocus-toggle" # Toggle HyprFocus
        # "$mod,P, exec,  uwsm app -- ${pkgs.planify}/bin/io.github.alainm23.planify" # Planify

        "$mod,Q, killactive," # Close window
        "$mod,T, togglefloating," # Toggle Floating
        "$mod,F, fullscreen" # Toggle Fullscreen
        "$mod,left, movefocus, l" # Move focus left
        "$mod,right, movefocus, r" # Move focus Right
        "$mod,up, movefocus, u" # Move focus Up
        "$mod,down, movefocus, d" # Move focus Down
        "$shiftMod,up, focusmonitor, -1" # Focus previous monitor
        "$shiftMod,down, focusmonitor, 1" # Focus next monitor
        "$shiftMod,left, layoutmsg, addmaster" # Add to master
        "$shiftMod,right, layoutmsg, removemaster" # Remove from master

        "$mod,PRINT, exec, screenshot region" # Screenshot region
        ",PRINT, exec, screenshot monitor" # Screenshot monitor
        "$shiftMod,PRINT, exec, screenshot window" # Screenshot window
        "ALT,PRINT, exec, screenshot region swappy" # Screenshot region then edit

        "$shiftMod,E, exec, ${pkgs.wofi-emoji}/bin/wofi-emoji" # Emoji picker with wofi
        "$mod,F2, exec, night-shift" # Toggle night shift
        "$mod,F3, exec, night-shift" # Toggle night shift
      ]
      ++ (builtins.concatLists (builtins.genList (i: let
          ws = i + 1;
        in [
          "$mod,code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT,code:1${toString i}, movetoworkspace, ${toString ws}"
        ])
        9));

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,R, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",XF86AudioMute, exec, dms ipc call audio mute" # Toggle Mute
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next" # Next Song
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous" # Previous Song
      ",switch:Lid Switch, exec, dms ipc call lock lock" # Lock when closing Lid
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, dms ipc call audio increment 3" # Sound Up
      ",XF86AudioLowerVolume, exec, dms ipc call audio decrement 3" # Sound Down
      ",XF86MonBrightnessUp, exec, dms ipc call brightness increment 5 \"\"" # Brightness Up
      ",XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5 \"\"" # Brightness Down
    ];
  };
}
