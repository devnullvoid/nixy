# Cleanup scripts for switching between configurations
{ pkgs, ... }:

let
  hyprland-cleanup = pkgs.writeShellScriptBin "hyprland-cleanup"
    # bash
    ''
      echo "🧹 Cleaning up Hyprland cache and config conflicts..."
      
      # Remove Hyprland cache
      rm -rf ~/.cache/hyprland/
      
      # Remove Hyprland logs  
      rm -rf ~/.local/share/hyprland/
      
      # Remove shader cache
      rm -rf ~/.cache/nvidia/GLCache/
      rm -rf ~/.cache/mesa_shader_cache/
      
      # Remove other compositor caches that might conflict
      rm -rf ~/.cache/wofi/
      rm -rf ~/.cache/waybar/
      
      echo "✅ Hyprland cleanup complete!"
      echo "💡 You may need to restart Hyprland for changes to take effect."
    '';

  config-cleanup = pkgs.writeShellScriptBin "config-cleanup"
    # bash
    ''
      echo "🧹 Cleaning up configuration conflicts..."
      
      # Clean XDG cache
      rm -rf ~/.cache/fontconfig/
      rm -rf ~/.cache/gdk-pixbuf-2.0/
      rm -rf ~/.cache/gtk-*
      
      # Clean user systemd services that might conflict
      systemctl --user daemon-reload
      
      # Clean dconf settings that might conflict
      dconf reset -f /
      
      echo "✅ Configuration cleanup complete!"
    '';

in { 
  home.packages = [ hyprland-cleanup config-cleanup ]; 
} 