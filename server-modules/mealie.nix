{ config, ... }:
let domain = "mealie.${config.var.rootdomain}";
in {
  services = {
    mealie = {
      enable = true;
      port = 8092;
    };

    nginx.virtualHosts."${domain}" = {
      useACMEHost = config.var.rootdomain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.mealie.port}";
      };
    };
  };
}
