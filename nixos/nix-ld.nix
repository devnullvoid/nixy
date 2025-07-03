# Nix-ld - Run unpatched dynamic binaries on NixOS
# This is needed for vscode-server and other non-NixOS binaries
{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Add common libraries that might be needed
      stdenv.cc.cc.lib
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
      
      # For vscode-server specifically
      libsecret
      util-linux
      
      # Graphics libraries
      libGL
      libdrm
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      
      # Audio libraries
      alsa-lib
      libpulseaudio
    ];
  };
} 