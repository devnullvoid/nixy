{ config, ... }:
let domain = "search-nixos-api.${config.var.rootdomain}";
in {
  services = {
    search-nixos-api = { enable = true; };

    nginx.virtualHosts."${domain}" = {
      useACMEHost = config.var.rootdomain;
      forceSSL = true;
      locations."/" = {
        proxyPass =
          "http://127.0.0.1:${toString config.services.search-nixos-api.port}/";
      };
    };
  };
}
