# Nix-index - Find packages and run them with comma
# https://github.com/bennofs/nix-index
{
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  
  programs.nix-index-database.comma.enable = true;
} 