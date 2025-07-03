{
  imports = [
    # Core shell configuration
    ./fish.nix
    ./starship.nix
    ./tmux.nix
    
    # Shell integrations and tools
    ./fzf.nix
    ./zoxide.nix
    ./eza.nix
    
    # Additional shell tools from devnullvoid-nix
    ./atuin.nix
    ./broot.nix
    ./yazi.nix
    ./navi.nix
    ./carapace.nix
    ./mise.nix
    ./pay-respects.nix
    ./direnv.nix
    ./nix-index.nix
    
    # Fish enhancements
    ./fish-abbreviations.nix
    ./fish-functions.nix
  ];
}
