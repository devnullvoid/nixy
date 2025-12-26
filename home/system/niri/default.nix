{
  pkgs,
  lib,
  config,
  ...
}: let
  accent = "#${config.theme.accent}";
  background = "#${config.lib.stylix.colors.base00}";
  foreground = "#${config.lib.stylix.colors.base05}";
  innerGaps = toString config.theme.gaps-in;
  outerGaps = toString config.theme.gaps-out;
  cursorSize = "28";
  configText = ''
    niri {
      version = 1

      colors {
        border = "${accent}"
        background = "${background}"
        text = "${foreground}"
      }

      gaps {
        inner = ${innerGaps}
        outer = ${outerGaps}
      }

      cursor {
        size = ${cursorSize}
      }

      layout {
        focus-follows-mouse = false
        main-column-ratio = 0.55
      }

      binds {
        bind {
          mods = ["SUPER"]
          key = "Return"
          command = "kitty"
        }

        bind {
          mods = ["SUPER"]
          key = "Q"
          command = "niri msg close-window"
        }

        bind {
          mods = ["SUPER"]
          key = "Space"
          command = "anyrun"
        }

        bind {
          mods = ["SUPER"]
          key = "B"
          command = "firefox"
        }

        bind {
          mods = ["SUPER"]
          key = "D"
          command = "dms run"
        }

        bind {
          mods = ["SUPER"]
          key = "E"
          command = "thunar"
        }

        bind {
          mods = ["SUPER"]
          key = "L"
          command = "hyprlock"
        }

        bind {
          mods = ["SUPER"]
          key = "V"
          command = "cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        }

        bind {
          mods = ["SUPER"]
          key = "F"
          command = "niri msg fullscreen"
        }

        bind {
          mods = ["SUPER"]
          key = "Up"
          command = "niri msg focus-window up"
        }

        bind {
          mods = ["SUPER"]
          key = "Down"
          command = "niri msg focus-window down"
        }

        bind {
          mods = ["SUPER"]
          key = "Left"
          command = "niri msg focus-window left"
        }

        bind {
          mods = ["SUPER"]
          key = "Right"
          command = "niri msg focus-window right"
        }
      }
    }
  '';
in {
  home.packages = lib.mkAfter [
    pkgs.niri
    pkgs.wlr-randr
  ];

  xdg.configFile."niri/config.kdl".text = configText;
}
