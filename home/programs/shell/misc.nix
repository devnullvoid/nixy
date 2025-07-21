{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
  ];
  programs = {
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
    };
    fd = {
      enable = true;
    };
    mods = {
      enable = true;
      enableFishIntegration = true;
    };
    ripgrep = {
      enable = true;
    };
    skim = {
      enable = true;
      enableFishIntegration = true;
    };
    television = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
