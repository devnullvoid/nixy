# nixvm fallback configuration using X11 + i3 for debugging display issues
{ config, pkgs, ... }: {
  imports = [
    # Basic system configuration
    # ../../nixos/audio.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ./bootloader.nix  # VM-specific bootloader (GRUB for MBR)
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/ssh.nix

    # VM optimizations - but don't disable essential services
    ./vm-optimizations-safe.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables-x11.nix
  ];

  # Use X11 instead of Wayland for debugging
  services.xserver = {
    enable = true;
    
    # VirtIO-GPU X11 driver
    videoDrivers = [ "modesetting" ];
    
    # Simple display manager instead of SDDM
    displayManager = {
      lightdm = {
        enable = true;
        background = "#000000";
        greeters.gtk = {
          enable = true;
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
          };
        };
      };
      defaultSession = "none+i3";
    };
    
    # i3 window manager (lightweight, reliable)
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
    
    # Basic X11 configuration
    xkb.layout = "us";
    xkb.variant = "";
  };

  # VirtIO-GPU specific graphics configuration for X11
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # VirtIO-GPU drivers for X11
      mesa
      libva
      libva-utils
      # VirtGL renderer for 3D acceleration
      virglrenderer
      # SPICE graphics support
      spice-gtk
      # X11 OpenGL support
      libGL
      libGLU
    ];
  };

  # VirtIO-GPU kernel modules
  boot = {
    kernelModules = [
      "virtio_gpu"
      "virtio_pci" 
      "drm"
      "drm_kms_helper"
    ];
    
    # VirtIO-GPU kernel parameters
    kernelParams = [
      "virtio_gpu.force_probe=1"
    ];
    
    # Enable early KMS
    initrd.kernelModules = [ "virtio_gpu" ];
  };

  # Enable VirtIO and SPICE guest services
  services = {
    # SPICE guest agent
    spice-vdagentd.enable = true;
    
    # QEMU guest agent
    qemuGuest.enable = true;
  };

  # Ensure user has proper permissions
  users.users.jon.extraGroups = [ "video" "render" "input" ];

  # Simple home-manager configuration for X11
  home-manager.users."${config.var.username}" = {
    imports = [
      ./variables-x11.nix
      ../../home/programs/git
      ../../home/programs/kitty
    ];
    
    home = {
      inherit (config.var) username;
      homeDirectory = "/home/" + config.var.username;
      stateVersion = "25.05";
      
      packages = with pkgs; [
        firefox
        curl
        wget
        htop
        tree
        file
        unzip
        # X11 tools
        xorg.xrandr
        xorg.xdpyinfo
        glxinfo
        mesa-demos
      ];
    };
    
    xdg.enable = true;
    programs.home-manager.enable = true;
    
    # i3 configuration
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";  # Super key
        terminal = "kitty";
        menu = "dmenu_run";
        
        keybindings = {
          "Mod4+Return" = "exec kitty";
          "Mod4+d" = "exec dmenu_run";
          "Mod4+Shift+q" = "kill";
          "Mod4+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        };
        
        bars = [{
          position = "top";
          statusCommand = "i3status";
        }];
      };
    };
    
    programs.bash = {
      enable = true;
      shellAliases = {
        ll = "ls -la";
        la = "ls -la";
        c = "clear";
      };
    };
  };

  # Add debugging tools
  environment.systemPackages = with pkgs; [
    # X11 debugging tools
    xorg.xrandr
    xorg.xdpyinfo
    xorg.xwininfo
    xorg.xev
    # Graphics debugging
    glxinfo
    mesa-demos
    # VirtIO debugging
    pciutils
  ];

  # Don't touch this
  system.stateVersion = "25.05";
} 