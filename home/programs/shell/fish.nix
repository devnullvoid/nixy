# My fish shell configuration
{ pkgs, lib, config, ... }:
let fetch = config.theme.fetch; # neofetch, nerdfetch, pfetch
in {

  home.packages = with pkgs; [ 
    # Core shell tools
    ripgrep tldr sesh rmtrash trash-cli 

    # Additional useful CLI tools from devnullvoid-nix
    any-nix-shell # for fish integration
    fd # modern find replacement
    jq # JSON processor
    yq-go # YAML processor
    glow # markdown previewer
    nix-output-monitor # better nix output with nom command
    
    # File management
    nnn # terminal file manager (alternative to yazi)
    
    # Archives
    zip unzip p7zip xz
    
    # System monitoring
    iotop iftop
    
    # Network tools
    mtr traceroute dnsutils
  ];

  home.sessionPath = [ "$HOME/go/bin" ];

  programs.fish = {
    enable = true;
    
    interactiveShellInit = ''
      # Set fish greeting
      set fish_greeting
      
      # Set cursor shapes for vi mode (block cursor for all modes)
      set -g fish_cursor_default block
      set -g fish_cursor_insert block
      # set -g fish_cursor_replace block
      # set -g fish_cursor_replace_one block
      # set -g fish_cursor_visual block
      # set -g fish_cursor_external block
      
      # any-nix-shell integration for better nix-shell experience
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      
      # Run fetch program
      ${if fetch == "neofetch" then
        "${pkgs.neofetch}/bin/neofetch"
      else if fetch == "nerdfetch" then
        "nerdfetch"
      else if fetch == "pfetch" then
        "echo; ${pkgs.pfetch}/bin/pfetch"
      else
        ""}

      # Enable vi mode
      fish_vi_key_bindings
      
      # Bind Alt+s to sesh-sessions function
      bind -M insert \es sesh-sessions
      bind -M default \es sesh-sessions
      
      ${lib.optionalString config.services.gpg-agent.enable ''
        # Set up GPG agent for SSH
        set gnupg_path (ls $XDG_RUNTIME_DIR/gnupg | head -1)
        set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gnupg/$gnupg_path/S.gpg-agent.ssh"
      ''}
    '';

    functions = {
      sesh-sessions = {
        body = ''
          set session (sesh list -t -c | fzf --height 70% --reverse)
          if test -n "$session"
            sesh connect $session
          end
        '';
      };

      chatgptfolder = {
        body = ''
          echo "################################"
          echo "###         TREE             ###"
          echo "################################"
          ${pkgs.eza}/bin/eza --tree -aF --icons never
          echo -e "\n\n"
          echo "##############################"
          echo "###        CONTENT         ###"
          echo "##############################"
          find . -type f -not -path '*/.git/*' -print0 | while read -d "" file
              echo -e "\n--- DEBUT: $file ---\n"
              cat "$file"
              echo -e "\n--- FIN: $file ---\n"
          end
        '';
      };

      n4c = {
        body = ''
          set target $argv[1]
          if test -z "$target"
            set target "all"
          end
          nix develop --no-write-lock-file --refresh "github:nix4cyber/n4c#$target" -c fish
        '';
      };
    };

    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      v = "nvim";
      c = "clear";
      clera = "clear";
      celar = "clear";
      e = "exit";
      cd = "z";
      ls = "eza --icons=always --no-quotes";
      tree = "eza --icons=always --tree --no-quotes";
      sl = "ls";
      open = "${pkgs.xdg-utils}/bin/xdg-open";
      icat = "${pkgs.kitty}/bin/kitty +kitten icat";
      cat = "bat --theme=base16 --color=always --paging=never --tabs=2 --wrap=never --plain";
      mkdir = "mkdir -p";
      rm = "${pkgs.rmtrash}/bin/rmtrash";
      rmdir = "${pkgs.rmtrash}/bin/rmdirtrash";

      obsidian-no-gpu = "env ELECTRON_OZONE_PLATFORM_HINT=auto obsidian --ozone-platform=x11";
      wireguard-import = "nmcli connection import type wireguard file";

      notes = "nvim ~/nextcloud/notes/index.md --cmd 'cd ~/nextcloud/notes' -c ':lua Snacks.picker.smart()'";
      note = "notes";
      tmp = "nvim /tmp/(date | sed 's/ //g;s/\\.//g').md";

      nix-shell = "nix-shell --command fish";

      # git
      g = "lazygit";
      ga = "git add";
      gc = "git commit";
      gcu = "git add . && git commit -m 'Update'";
      gp = "git push";
      gpl = "git pull";
      gs = "git status";
      gd = "git diff";
      gco = "git checkout";
      gcb = "git checkout -b";
      gbr = "git branch";
      grs = "git reset HEAD~1";
      grh = "git reset --hard HEAD~1";

      gaa = "git add .";
      gcm = "git commit -m";

      # Nix and NixOS
      nixb = "nix build";
      nixr = "nix run";
      nixe = "nix eval";
      nixi = "nix-instantiate";
      nixs = "nix-shell";
      nixd = "nix develop";
      nixc = "nix-collect-garbage -d";
      nixg = "nix-env -qaP | grep";
      nixu = "nix flake update";
      nixfmt = "nixpkgs-fmt";
      nrs = "nix repl '<nixpkgs>'";
      nlog = "journalctl -xeu nix-daemon.service";

      # NixOS specific
      nrsw = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      nrb = "sudo nixos-rebuild boot";
      nru = "sudo nixos-rebuild dry-run";
      nrsf = "sudo nixos-rebuild switch --flake .#";
      nrswf = "sudo nixos-rebuild switch --flake .# --show-trace";
      nrswq = "sudo nixos-rebuild switch --upgrade";
    };

    shellAbbrs = {
      # Navigation shortcuts
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      
      # Git shortcuts (complementary to aliases)
      gapa = "git add --patch";
      grpa = "git reset --patch";
      gst = "git status";
      gdh = "git diff HEAD";
      gph = "git push -u origin HEAD";
      gcob = "git checkout -b";
      gcom = "git checkout master";  # renamed from gcm to avoid conflict
      gcd = "git checkout develop";
      gsp = "git stash push -m";
      gsa = "git stash apply stash^{/";
      gsl = "git stash list";

      # Nix and NixOS
      nb = "nix build";
      nr = "nix run";
      ns = "nix shell";
      nd = "nix develop";
      ncg = "nix-collect-garbage -d";
      nfu = "nix flake update";
      nrepl = "nix repl '<nixpkgs>'";
      nfmt = "nixpkgs-fmt";

      # NixOS specific
      nsw = "sudo nixos-rebuild switch";
      nt = "sudo nixos-rebuild test";
      nbt = "sudo nixos-rebuild boot";
      ndn = "sudo nixos-rebuild dry-run";
      nswf = "sudo nixos-rebuild switch --flake .#";
      nswq = "sudo nixos-rebuild switch --upgrade";
    };
  };
} 