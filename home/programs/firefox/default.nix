# Firefox browser configuration
{ pkgs, config, ... }: {
  programs.firefox = {
    enable = true;
    profiles = {
      "${config.var.username}" = {
        isDefault = true;
        extensions.force = true;
      };
    };
  };
  programs.librewolf = {
    enable = true;
    profiles = {
      "${config.var.username}" = {
        isDefault = true;
        extensions.force = true;
      };
    };
  };

  stylix.targets = {
    firefox = {
      enable = true;
      profileNames = [ config.var.username ];
      colorTheme.enable = true;
    };
    librewolf = {
      enable = true;
      profileNames = [ config.var.username ];
      colorTheme.enable = true;
    };
  };
} 