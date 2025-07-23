{ config, ... }:
let domain = "meilisearch.${config.var.rootdomain}";
in {
  services = {
    meilisearch = {
      enable = true;
      listenPort = 7700;
      # masterKeyEnvironmentFile= "";
    };
    nginx.virtualHosts."${domain}" = {
      useACMEHost = config.var.rootdomain;
      forceSSL = true;
      locations."/" = {
        proxyPass =
          "http://127.0.0.1:${toString config.services.meilisearch.listenPort}";
      };
    };
  };
}
