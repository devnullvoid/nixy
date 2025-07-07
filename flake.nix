{
  # https://github.com/anotherhadi/nixy
  description = ''
    Nixy simplifies and unifies the Hyprland ecosystem with a modular, easily customizable setup.
    It provides a structured way to manage your system configuration and dotfiles with minimal effort.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    stylix.url = "github:danth/stylix";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixcord.url = "github:kaylorben/nixcord";
    sops-nix.url = "github:Mic92/sops-nix";
    nixarr.url = "github:rasmus-kirk/nixarr";
    anyrun.url = "github:fufexan/anyrun/launch-prefix";
    nvf.url = "github:notashelf/nvf";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    search-nixos-api.url = "github:anotherhadi/search-nixos-api";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {nixpkgs, ...}: {
    nixosConfigurations = {
      procyon =
        nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.overlays = [inputs.hyprpanel.overlay];
              _module.args = {inherit inputs;};
            }
            inputs.nixos-hardware.nixosModules.dell-latitude-5520 # CHANGEME: check https://github.com/NixOS/nixos-hardware
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            ./hosts/procyon/configuration.nix # CHANGEME: change the path to match your host folder
          ];
        };
      nixy =
        # CHANGEME: This should match the 'hostname' in your variables.nix file
        nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.overlays = [inputs.hyprpanel.overlay];
              _module.args = {inherit inputs;};
            }
            inputs.nixos-hardware.nixosModules.omen-16-n0005ne # CHANGEME: check https://github.com/NixOS/nixos-hardware
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            ./hosts/laptop/configuration.nix # CHANGEME: change the path to match your host folder
          ];
        };
      # Jack is my server
      jack = nixpkgs.lib.nixosSystem {
        modules = [
          {_module.args = {inherit inputs;};}
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          inputs.nixarr.nixosModules.default
          inputs.search-nixos-api.nixosModules.search-nixos-api
          ./hosts/server/configuration.nix
        ];
      };
      # Lean VM configuration for testing
      nixvm = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.overlays = [inputs.hyprpanel.overlay];
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/nixvm/configuration.nix
        ];
      };
      
      # Debug minimal configuration
      nixvm-debug = nixpkgs.lib.nixosSystem {
        modules = [
          {
            _module.args = {inherit inputs;};
          }
          ./hosts/nixvm/debug-minimal.nix
        ];
      };
      
      # Debug step 1: Add home-manager
      nixvm-step1 = nixpkgs.lib.nixosSystem {
        modules = [
          {
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          ./hosts/nixvm/debug-step1.nix
        ];
      };
      
      # Debug step 2: Add shell configuration
      nixvm-step2 = nixpkgs.lib.nixosSystem {
        modules = [
          {
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          ./hosts/nixvm/debug-step2.nix
        ];
      };
      
      # Debug step 3: Add essential programs
      nixvm-step3 = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.overlays = [inputs.hyprpanel.overlay];
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          ./hosts/nixvm/debug-step3.nix
        ];
      };
      
      # Debug step 4: Add complex program configurations
      nixvm-step4 = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.overlays = [inputs.hyprpanel.overlay];
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          ./hosts/nixvm/debug-step4.nix
        ];
      };
      
      # Debug step 4b: Add variables.nix support
      nixvm-step4b = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.overlays = [inputs.hyprpanel.overlay];
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          ./hosts/nixvm/debug-step4b.nix
        ];
      };
      
      # Debug step 4c: Variables without theme (no Stylix)
      nixvm-step4c = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.overlays = [inputs.hyprpanel.overlay];
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          ./hosts/nixvm/debug-step4c.nix
        ];
      };
      
      # Debug step 4d: Pass variables to home-manager context
      nixvm-step4d = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.overlays = [inputs.hyprpanel.overlay];
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          ./hosts/nixvm/debug-step4d.nix
        ];
      };
      
      # Debug step 5: Add Stylix support for full theme configuration
      nixvm-step5 = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.overlays = [inputs.hyprpanel.overlay];
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/nixvm/debug-step5.nix
        ];
      };
      
      # Debug step 6: Import variables.nix in both contexts (like procyon)
      nixvm-step6 = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.overlays = [inputs.hyprpanel.overlay];
            _module.args = {inherit inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/nixvm/debug-step6.nix
        ];
      };
    };
  };
}
