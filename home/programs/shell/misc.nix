{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
    bat-extras.core
    bat-extras.batwatch
    bat-extras.batgrep
    bat-extras.batman
    bat-extras.batdiff
  ];
  programs = {
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
    };
    mods = {
      enable = true;
      enableFishIntegration = true;
    };
    television = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
