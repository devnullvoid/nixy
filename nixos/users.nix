{ config, pkgs, ... }:
let username = config.var.username;
in {
  # Enable shells system-wide
  programs.fish.enable = true;
  # programs.bash.enable = true;
  
  # Ensure shells are available in system packages
  environment.systemPackages = with pkgs; [
    fish
    bash
    zsh
  ];
  
  users = {
    # Use bash as default to avoid login loops, user can change later
    defaultUserShell = pkgs.bash;
    users.${username} = {
      isNormalUser = true;
      description = "${username} account";
      extraGroups = [ "networkmanager" "wheel" ];
      # Set initial password for easy VM access
      initialPassword = "jon";
      # Use bash as default shell for stability
      shell = pkgs.fish;
    };
  };
}
