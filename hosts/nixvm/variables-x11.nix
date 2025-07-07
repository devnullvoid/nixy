# Simplified variables for X11 fallback without theme dependencies
{ lib, ... }: {
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };
  
  config.var = {
    hostname = "nixvm-x11";
    username = "jon";
    autoGarbageCollector = false;
    keyboardLayout = "us";
    
    # Skip theme imports to avoid Stylix dependencies
    location = "Paris";
    timeZone = "Europe/Paris";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "fr_FR.UTF-8";
    
    # Additional variables required by utils.nix
    autoUpgrade = false;
    configDirectory = "/home/jon/Dev/nixy";
    
    # Git configuration
    git = {
      username = "jon";
      email = "jon@example.com";
    };
  };
} 