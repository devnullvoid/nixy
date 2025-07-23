{ config, ... }: {
  services.nginx = { enable = true; };

  security.acme = {
    acceptTerms = true;
    defaults.email = config.var.git.email;
  };

  security.acme.certs."${config.var.rootdomain}" = {
    domain = config.var.rootdomain;
    extraDomainNames = [ "*.${config.var.rootdomain}" ];
    group = "nginx";

    dnsProvider = "cloudflare";
    dnsPropagationCheck = true;
    credentialsFile = config.sops.secrets.cloudflare-dns-token.path;
  };

  services.nginx.virtualHosts = {
    "default" = {
      default = true;
      locations."/" = { return = 444; };
    };
    "*.${config.var.rootdomain}" = {
      useACMEHost = config.var.rootdomain;
      forceSSL = true;
      locations."/" = { return = 444; };
    };
    "aaaaaa.${config.var.rootdomain}" = {
      useACMEHost = config.var.rootdomain;
      forceSSL = true;
      locations."/" = { return = 444; };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 80 443 ];
}
