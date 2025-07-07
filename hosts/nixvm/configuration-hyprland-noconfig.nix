# Hyprland configuration with NO custom config - use defaults
{ config, pkgs, lib, inputs, ... }: 

let
  # Pin to nixpkgs-24.05 which should have pre-Aquamarine Hyprland
  oldPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
    sha256 = "0zydsqiaz8qi4zd63zsb2gij2p614cgkcaisnk11wjy3nmiq0x1s";
  }) { system = pkgs.system; };
in
{
  imports = [
    ../../nixos/nix.nix
    ./bootloader.nix
    ./hardware-configuration.nix
    ./variables-x11.nix  # Use simplified variables
  ];

  # Minimal user setup
  users.users.jon = {
    isNormalUser = true;
    description = "jon account";
    extraGroups = [ "wheel" "video" "render" "input" "kvm" ];
    initialPassword = "jon";
    shell = pkgs.bash;
  };

  # Basic VirtIO-GPU kernel configuration
  boot = {
    kernelModules = [ "virtio_gpu" "drm" "drm_kms_helper" ];
    kernelParams = [
      "virtio_gpu.force_probe=1"
      "virtio_gpu.modeset=1"
    ];
    initrd.kernelModules = [ "virtio_gpu" ];
  };

  # Basic hardware graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      virglrenderer
      libdrm
    ];
  };

  # Minimal environment variables - only the essentials
  environment.variables = {
    # Force software rendering for stability
    "WLR_RENDERER" = "pixman";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "LIBGL_ALWAYS_SOFTWARE" = "1";
    
    # Basic compatibility
    "HYPRLAND_NO_RT" = "1";
    "HYPRLAND_NO_SD_NOTIFY" = "1";
  };

  # Use old Hyprland from 24.05 (pre-Aquamarine)
  environment.systemPackages = with pkgs; [
    # Use older Hyprland version
    oldPkgs.hyprland
    
    # Basic terminals
    kitty
    foot
    
    # Basic tools
    firefox
    
    # Debugging tools
    pciutils
    wayland-utils
    wlr-randr
    glxinfo
    mesa-demos
  ];

  # Create Hyprland desktop entry
  environment.etc."wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Comment=An intelligent dynamic tiling Wayland compositor
    Exec=${oldPkgs.hyprland}/bin/Hyprland
    Type=Application
  '';

  # SDDM configuration
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      General = {
        DefaultSession = "hyprland.desktop";
      };
    };
  };

  # DO NOT create any custom Hyprland config - let it use defaults
  # This will test if our custom config was the problem

  # Networking
  networking = {
    hostName = "nixvm-hyprland-noconfig";
    networkmanager.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
} 