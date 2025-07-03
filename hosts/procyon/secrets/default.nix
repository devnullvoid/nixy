# Those are my secrets, encrypted with sops
# You shouldn't import this file, unless you edit it
{ pkgs, inputs, ... }: {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "/home/jon/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      sshconfig = { path = "/home/jon/.ssh/config"; };
      github-key = { path = "/home/jon/.ssh/github"; };
      gitlab-key = { path = "/home/jon/.ssh/gitlab"; };
      devnullvoid-key = { path = "/home/jon/.ssh/devnullvoid"; };
      mikrotik-key = { path = "/home/jon/.ssh/mikrotik"; };
      signing-key = { path = "/home/jon/.ssh/key"; };
      signing-pub-key = { path = "/home/jon/.ssh/key.pub"; };
      # pia = { path = "/home/jon/.config/pia/pia.ovpn"; };
    };
  };

  home.file.".config/nixos/.sops.yaml".text = ''
    keys:
      - &primary age1k9n9pj7y46nk4sta3ghsvd5x9785yrh6fkga4glyex54y2es045qxqpzm3
    creation_rules:
      - path_regex: hosts/procyon/secrets/secrets.yaml$
        key_groups:
          - age:
            - *primary
  '';

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
  home.packages = with pkgs; [ sops age ];

  wayland.windowManager.hyprland.settings.exec-once =
    [ "systemctl --user start sops-nix" ];
}
