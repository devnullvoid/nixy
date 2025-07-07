{
  description = "Minimal Hyprland test flake for VirtIO-GPU";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Use stable nixpkgs for older Hyprland without Aquamarine
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, nixpkgs-stable }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        # Test with stable Hyprland (pre-Aquamarine)
        hyprland-test-stable = nixpkgs-stable.lib.nixosSystem {
          system = system;
          modules = [
            ./configuration-stable.nix
          ];
        };

        # Test with unstable Hyprland (with Aquamarine)
        hyprland-test-unstable = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./configuration-unstable.nix
          ];
        };

        # Test with headless backend only
        hyprland-test-headless = nixpkgs-stable.lib.nixosSystem {
          system = system;
          modules = [
            ./configuration-headless.nix
          ];
        };
      };
    };
} 