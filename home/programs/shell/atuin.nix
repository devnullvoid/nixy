# Atuin - Magical shell history
# https://github.com/atuinsh/atuin
{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      enter_accept = true;
      inline_height = 20;
    };
  };
} 