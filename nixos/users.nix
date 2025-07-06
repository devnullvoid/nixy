{ config, pkgs, ... }:
let username = config.var.username;
in {
  # Enable fish shell system-wide
  programs.fish.enable = true;
  
  # Ensure both fish and bash are available in system packages
  environment.systemPackages = with pkgs; [
    fish
    bash
    zsh
  ];
  
  users = {
    # defaultUserShell = pkgs.fish;
    users.${username} = {
      isNormalUser = true;
      description = "${username} account";
      extraGroups = [ "networkmanager" "wheel" ];
      # Set empty password for easy VM access (change this for production!)
      initialPassword = "jon";
      # Use fish as default, but bash is available as fallback
      shell = pkgs.fish;
    };
  };
}
