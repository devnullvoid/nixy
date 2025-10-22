{pkgs, config, ...}: {
  sops = {
    age.keyFile = "/home/${config.var.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      sshconfig = {
        owner = config.var.username;
        path = "/home/${config.var.username}/.ssh/config";
        mode = "0600";
      };
      github-key = {
        owner = config.var.username;
        path = "/home/${config.var.username}/.ssh/github";
        mode = "0600";
      };
      signing-key = {
        owner = config.var.username;
        path = "/home/${config.var.username}/.ssh/key";
        mode = "0600";
      };
      signing-pub-key = {
        owner = config.var.username;
        path = "/home/${config.var.username}/.ssh/key.pub";
        mode = "0600";
      };
      cloudflare-dns-token = {path = "/etc/cloudflare/dnskey.txt";};
      nextcloud-pwd = {path = "/etc/nextcloud/pwd.txt";};
      adguard-pwd = {};
      hoarder = {};
    };
  };

  environment.systemPackages = with pkgs; [sops age];
}
