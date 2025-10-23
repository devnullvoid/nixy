{ pkgs, ... }:
let
  dms-toggle = pkgs.writeShellScriptBin "dms-toggle" ''
    dms ipc call bar toggle
  '';

  dms-show = pkgs.writeShellScriptBin "dms-show" ''
    dms ipc call bar reveal
  '';

  dms-hide = pkgs.writeShellScriptBin "dms-hide" ''
    dms ipc call bar hide
  '';

  dms-reload = pkgs.writeShellScriptBin "dms-reload" ''
    if systemctl --user status dms.service >/dev/null 2>&1
    then
      systemctl --user restart dms.service
    else
      dms run
    fi
  '';

in {
  home.packages = [ dms-toggle dms-show dms-hide dms-reload ];
}
