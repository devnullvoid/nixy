# Fzf is a general-purpose command-line fuzzy finder.
{ config, lib, ... }:
let
  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" ] {} config;
  baseColor = name: default:
    let value = lib.attrByPath [ name ] default stylixColors;
    in if builtins.isString value then value else default;
  accent =
    if lib.hasAttrByPath [ "theme" "accent" ] config then
      "#${config.theme.accent}"
    else "#${baseColor "base08" "89b4fa"}";
  foreground = "#${baseColor "base05" "cdd6f4"}";
  muted = "#${baseColor "base03" "6c7086"}";
in {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    colors = lib.mkForce {
      "fg+" = accent;
      "bg+" = "-1";
      "fg" = foreground;
      "bg" = "-1";
      "prompt" = muted;
      "pointer" = accent;
    };
    defaultOptions = [
      "--margin=1"
      "--layout=reverse"
      "--border=none"
      "--info='hidden'"
      "--header=''"
      "--prompt='/ '"
      "-i"
      "--no-bold"
    ];
  };
}
