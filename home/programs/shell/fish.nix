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
    
    # Set fish colors using config.lib.stylix.colors
    shellInit = ''
      # Base colors from stylix
      set -l base00 ${config.lib.stylix.colors.base00}
      set -l base01 ${config.lib.stylix.colors.base01}
      set -l base02 ${config.lib.stylix.colors.base02}
      set -l base03 ${config.lib.stylix.colors.base03}
      set -l base04 ${config.lib.stylix.colors.base04}
      set -l base05 ${config.lib.stylix.colors.base05}
      set -l base06 ${config.lib.stylix.colors.base06}
      set -l base07 ${config.lib.stylix.colors.base07}
      set -l base08 ${config.lib.stylix.colors.base08}
      set -l base09 ${config.lib.stylix.colors.base09}
      set -l base0A ${config.lib.stylix.colors.base0A}
      set -l base0B ${config.lib.stylix.colors.base0B}
      set -l base0C ${config.lib.stylix.colors.base0C}
      set -l base0D ${config.lib.stylix.colors.base0D}
      set -l base0E ${config.lib.stylix.colors.base0E}
      set -l base0F ${config.lib.stylix.colors.base0F}
      set -l base10 ${config.lib.stylix.colors.base10 or config.lib.stylix.colors.base01}  # Fallback to base01 if base10 not available
      set -l base11 ${config.lib.stylix.colors.base11 or config.lib.stylix.colors.base00}  # Fallback to base00 if base11 not available
      set -l base12 ${config.lib.stylix.colors.base12 or config.lib.stylix.colors.base08}  # Fallback to base08 if base12 not available
      set -l base13 ${config.lib.stylix.colors.base13 or config.lib.stylix.colors.base06}  # Fallback to base06 if base13 not available
      set -l base14 ${config.lib.stylix.colors.base14 or config.lib.stylix.colors.base0B}  # Fallback to base0B if base14 not available
      set -l base15 ${config.lib.stylix.colors.base15 or config.lib.stylix.colors.base0C}  # Fallback to base0C if base15 not available
      set -l base16 ${config.lib.stylix.colors.base16 or config.lib.stylix.colors.base0D}  # Fallback to base0D if base16 not available
      set -l base17 ${config.lib.stylix.colors.base17 or config.lib.stylix.colors.base0E}  # Fallback to base0E if base17 not available
    '';
    
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
      
      # Set fish colors using stylix baseXX colors
      set -g fish_color_normal $base05
      set -g fish_color_command $base0D
      set -g fish_color_param $base06
      set -g fish_color_keyword $base0E
      set -g fish_color_quote $base0B
      set -g fish_color_redirection $base0E
      set -g fish_color_end $base09
      set -g fish_color_comment $base03
      set -g fish_color_error $base08
      set -g fish_color_gray $base04
      set -g fish_color_selection --background=$base02
      set -g fish_color_search_match --background=$base02
      set -g fish_color_option $base0B
      set -g fish_color_operator $base0E
      set -g fish_color_escape $base0C
      set -g fish_color_autosuggestion $base03
      set -g fish_color_cancel $base08
      set -g fish_color_cwd $base0A
      set -g fish_color_user $base0C
      set -g fish_color_host $base0D
      set -g fish_color_host_remote $base0B
      set -g fish_color_status $base08
      set -g fish_pager_color_progress $base04
      set -g fish_pager_color_prefix $base0E
      set -g fish_pager_color_completion $base05
      set -g fish_pager_color_description $base03
      
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

    plugins = [
      # AI assistant for fish shell
      {
        name = "fish-ai";
        src = pkgs.fetchFromGitHub {
          owner = "Realiserad";
          repo = "fish-ai";
          rev = "main";
          sha256 = "sha256-k4wK5RyJkPpw9MrO5GZKLJTAxc+4Ay4Ki3erCIJXfbU="; # You'll need to update this
        };
      }
    ];

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
      rebuild = "sudo nixos-rebuild switch --flake .#";
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