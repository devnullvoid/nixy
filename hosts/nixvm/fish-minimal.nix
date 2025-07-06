# Minimal Fish configuration for VM
# Avoids complex initialization that could cause login loops
{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    
    interactiveShellInit = ''
      # Set fish greeting
      set fish_greeting
      
      # Basic setup only - no complex initialization
      echo "Welcome to NixVM!"
    '';

    shellAliases = {
      # Basic aliases only
      vim = "nvim";
      vi = "nvim";
      c = "clear";
      e = "exit";
      ls = "ls --color=auto";
      ll = "ls -la";
      la = "ls -la";
      
      # Git basics
      g = "git";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gs = "git status";
    };
  };
} 