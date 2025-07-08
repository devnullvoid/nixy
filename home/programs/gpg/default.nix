# GPG agent configuration for SSH and signing
{ pkgs, ... }: {
  programs.gpg = {
    enable = true;
    homedir = "${builtins.getEnv "HOME"}/.gnupg";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-gtk2;
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = 3600;
    maxCacheTtl = 7200;
    maxCacheTtlSsh = 7200;
  };

  home.packages = with pkgs; [
    gnupg
    pinentry-gtk2
  ];
} 