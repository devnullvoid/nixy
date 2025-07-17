# VS Code configuration
{ pkgs, ... }: {
  # home.packages = with pkgs; [
  # ];

  programs.vscode = {
    enable = true;
  };
} 