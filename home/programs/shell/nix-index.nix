# Nix-index - Find packages and run them with comma
# https://github.com/bennofs/nix-index
{
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  
  # Use the correct module path for nix-index-database
  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;
} 