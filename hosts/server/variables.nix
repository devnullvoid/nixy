{ config, lib, ... }: {
  imports = [
    # Choose your theme here:
    ../../themes/nixy.nix
  ];

  config.var = {
    hostname = "server";
    username = "jon";
    configDirectory = "/home/" + config.var.username
      + "/.config/nixos"; # The path of the nixos configuration directory

    keyboardLayout = "us";

    location = "New York";
    timeZone = "America/New_York";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "en_US.UTF-8";

    rootdomain = "nully.dev";

    git = {
      username = "Jon";
      email = "jon@nully.dev";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;
  };

  # Let this here
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
