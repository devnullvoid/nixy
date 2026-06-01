{ pkgs, inputs, lib, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPackage = inputs.hyprland.packages.${system}.hyprland;
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  sessions = "${pkgs.niri}/share/wayland-sessions:${hyprlandPackage}/share/wayland-sessions";
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --remember-user-session --sessions ${sessions}";
        user = "greeter";
      };
    };
  };

  # Prevent greetd from spamming the journal on TTY
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
    ExecStartPre = "${pkgs.util-linux}/bin/setterm --blank 3 --powerdown 5";
  };

  environment.systemPackages = [ pkgs.tuigreet ];
}
