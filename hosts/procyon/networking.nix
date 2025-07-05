{ config, pkgs, inputs, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # SOPS configuration for system-level secrets
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "/home/${config.var.username}/.config/sops/age/keys.txt";
    secrets = {
      wifi-ssid = {
        mode = "0600";
        owner = "root";
        group = "root";
      };
      wifi-psk = {
        mode = "0600";
        owner = "root";
        group = "root";
      };
    };
  };

  networking = {
    networkmanager = {
      enable = true;
      # Use NetworkManager's declarative configuration with SOPS
      ensureProfiles = {
        environmentFiles = [ "/run/secrets/wifi-env" ];
        profiles = {
          "devnullvoid" = {
            connection = {
              id = "devnullvoid";
              type = "wifi";
              autoconnect = true;
            };
            wifi = {
              ssid = "$WIFI_SSID";
              mode = "infrastructure";
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$WIFI_PSK";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              method = "auto";
            };
          };
        };
      };
    };
  };

  # Create environment file from SOPS secrets
  system.activationScripts.wifi-env = {
    text = ''
      mkdir -p /run/secrets
      echo "WIFI_SSID=$(cat ${config.sops.secrets.wifi-ssid.path})" > /run/secrets/wifi-env
      echo "WIFI_PSK=$(cat ${config.sops.secrets.wifi-psk.path})" >> /run/secrets/wifi-env
      chmod 600 /run/secrets/wifi-env
    '';
    deps = [ "sops-nix" ];
  };
} 