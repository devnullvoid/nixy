# Lazygit is a simple terminal UI for git commands.
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
  muted = "#${baseColor "base03" "6c7086"}";
in {
  programs.lazygit = {
    enable = true;
    settings = lib.mkForce {
      disableStartupPopups = true;
      notARepository = "skip";
      promptToReturnFromSubprocess = false;
      update.method = "never";
      git = {
        commit.signOff = true;
        parseEmoji = true;
      };
      gui = {
        theme = {
          activeBorderColor = [ accent "bold" ];
          inactiveBorderColor = [ muted ];
        };
        showListFooter = false;
        showRandomTip = false;
        showCommandLog = false;
        showBottomLine = false;
        nerdFontsVersion = "3";
      };
    };
  };
  programs.gitui = {
    enable = true;
  };
}
