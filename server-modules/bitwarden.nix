{ config, ... }:
let domain = "vault.${config.var.rootdomain}";
in {
  services = {
    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://" + domain;
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
      };
    };

    nginx.virtualHosts."${domain}" = {
      useACMEHost = config.var.rootdomain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${
            toString config.services.vaultwarden.config.ROCKET_PORT
          }";
      };
    };
  };
}
