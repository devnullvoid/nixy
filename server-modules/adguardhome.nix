{ config, ... }:
let domain = "adguard.${config.var.rootdomain}";
in {
  services = {
    adguardhome = {
      enable = true;
      port = 3000;
    };

    nginx.virtualHosts."${domain}" = {
      useACMEHost = config.var.rootdomain;
      forceSSL = true;
      locations."/" = {
        proxyPass =
          "http://127.0.0.1:${toString config.services.adguardhome.port}";
      };
    };
  };
}
