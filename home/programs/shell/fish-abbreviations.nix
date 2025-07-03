# Fish shell abbreviations - shorthand expansions
{
  programs.fish = {
    shellAbbrs = {
      # Nix shortcuts
      gc = "nix-collect-garbage --delete-old";
      
      # Navigation shortcuts
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      
      # Git shortcuts
      gapa = "git add --patch";
      grpa = "git reset --patch";
      gst = "git status";
      gdh = "git diff HEAD";
      gp = "git push";
      gph = "git push -u origin HEAD";
      gco = "git checkout";
      gcob = "git checkout -b";
      gcm = "git checkout master";
      gcd = "git checkout develop";
      gsp = "git stash push -m";
      gsa = "git stash apply stash^{/";
      gsl = "git stash list";
    };
  };
} 