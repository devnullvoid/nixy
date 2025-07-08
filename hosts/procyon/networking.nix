{ config, pkgs, inputs, ... }:
let
  username = "jon";
in {
  # imports = [ inputs.sops-nix.nixosModules.sops ];

  # SOPS configuration for system-level secrets
  # sops = {
  #   defaultSopsFile = ./secrets/secrets.yaml;
  #   age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
  #   secrets = {
  #     wifi-ssid = {
  #       mode = "0600";
  #       owner = "root";
  #       group = "root";
  #     };
  #     wifi-psk = {
  #       mode = "0600";
  #       owner = "root";
  #       group = "root";
  #     };
  #   };
  # };

  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        backend = "wpa_supplicant";
        powersave = false;
      };
    };
    # Disable the global useDHCP flag as it's deprecated when using NetworkManager
    useDHCP = false;
  };

  # Create NetworkManager connection file from SOPS secrets (temporarily disabled)
  # systemd.services.create-wifi-connection = {
  #   description = "Create NetworkManager WiFi connection from SOPS secrets";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "sops-nix.service" "NetworkManager.service" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  #   script = ''
  #     # Create NetworkManager system connection directory
  #     mkdir -p /etc/NetworkManager/system-connections

  #     # Read secrets
  #     WIFI_SSID=$(cat ${config.sops.secrets.wifi-ssid.path})
  #     WIFI_PSK=$(cat ${config.sops.secrets.wifi-psk.path})

  #     # Create connection file
  #     cat > /etc/NetworkManager/system-connections/devnullvoid.nmconnection << EOF
  #     [connection]
  #     id=devnullvoid
  #     uuid=$(${pkgs.util-linux}/bin/uuidgen)
  #     type=wifi
  #     autoconnect=true
  #     autoconnect-priority=1

  #     [wifi]
  #     mode=infrastructure
  #     ssid=$WIFI_SSID

  #     [wifi-security]
  #     key-mgmt=wpa-psk
  #     psk=$WIFI_PSK

  #     [ipv4]
  #     method=auto

  #     [ipv6]
  #     addr-gen-mode=stable-privacy
  #     method=auto
  #     EOF

  #     # Set correct permissions
  #     chmod 600 /etc/NetworkManager/system-connections/devnullvoid.nmconnection
  #     chown root:root /etc/NetworkManager/system-connections/devnullvoid.nmconnection

  #     # Reload NetworkManager to pick up the new connection
  #     ${pkgs.systemd}/bin/systemctl reload-or-restart NetworkManager
  #   '';
  # };
} 