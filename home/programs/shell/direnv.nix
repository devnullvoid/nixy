# Direnv - Automatic environment loading
# https://github.com/direnv/direnv
{
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
} 