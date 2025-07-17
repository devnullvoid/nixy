# starship is a minimal, fast, and extremely customizable prompt for any shell!
{ config, lib, ... }:
let
  # accent = "#${config.lib.stylix.colors.color_13}";
  # background-alt = "#${config.lib.stylix.colors.color_01}";
  colors = config.lib.stylix.colors;
  lang = {
    style = "bg:color_13 fg:color_02";
    format = "[ $symbol( $version) ]($style)";
  };
  git = {
    style = "bg:color_07 fg:color_02 italic";
    format = "([\\[$all_status$ahead_behind\\] ]($style))";
  };
  container = {
    style = "bg:color_15 fg:color_02";
    format = "[ $symbol $name ]($style)";
  };
in {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "[](fg:color_02)"
        "$os"
        "[](bg:color_03 fg:color_02)"
        "$directory"
        "[](bg:color_07 fg:color_03)"
        "$git_branch$git_status"
        "[](fg:color_07 bg:color_13)"
        "$c$rust$golang$nodejs$java$python$kotlin$dotnet$package"
        "[](fg:color_13 bg:color_15)"
        "$container"
        "$docker_context"
        "$nix_shell"
        "$conda"
        "[ ](fg:color_15)"
        "$fill"
        "[ ](fg:color_02)"
        "$time"
        "[](fg:color_02)"
        "$line_break$character"
      ];

      # Theming
      palette = lib.mkForce"default";
      palettes.default = with colors.withHashtag; {
        color_00 = base00;
        color_01 = base01;
        color_02 = base02;
        color_03 = base03;
        color_04 = base04;
        color_05 = base05;
        color_06 = base06;
        color_07 = base07;
        color_08 = base08;
        color_09 = base09;
        color_10 = base0A;
        color_11 = base0B;
        color_12 = base0C;
        color_13 = base0D;
        color_14 = base0E;
        color_15 = base0F;
        color_16 = base10;
        color_17 = base11;
        color_18 = base12;
        color_19 = base13;
        color_20 = base14;
        color_21 = base15;
        color_22 = base16;
        color_23 = base17;
      };

      # Converts starship to use Nerd Font symbols
      # aws.symbol = " ";
      # buf.symbol = " ";
      # c.symbol = " ";
      # cmake.symbol = " ";
      # conda.symbol = " ";
      # crystal.symbol = " ";
      # dart.symbol = " ";
      directory = {
        style = "bg:color_03 fg:color_05";
        format = "[ $path ]($style)";
        truncation_length = 5;
        truncation_symbol = "…/";
        substitutions = {
          # "Documents" = "󰈙 ";
          # "Downloads" = "󰇚 ";
          # "Music" = "󰝚 ";
          # "Pictures" = " ";
          # "Dev" = "󰲋 ";
          "Applications" = "  ";
          "Desktop" = "  ";
          "Dev" = "  ";
          "Developer" = " 󰲋 ";
          "Documents" = " 󰈙 ";
          "Downloads" = "  ";
          "Games" = "  ";
          "GitHub" = "  ";
          "Library" = "  ";
          "Movies" = "  ";
          "Music" = "  ";
          "Pictures" = "  ";
          "Projects" = "  ";
          "Public" = "  ";
          "Screenshots" = " 󱣴 ";
          "Thunderbird" = "  ";
          "Firefox" = "  ";
          "Videos" = "  ";
          "github" = "  ";
          "source" = "  ";
          "~" = "  ";
          "~/.config" = "  ";
        };
        read_only = " 󰌾";
      };
      # docker_context.symbol = " ";
      # elixir.symbol = " ";
      # elm.symbol = " ";
      # fennel.symbol = " ";
      # fossil_branch.symbol = " ";
      # git_branch.symbol = " ";
      # git_commit.tag_symbol = "  ";
      # golang.symbol = " ";
      # guix_shell.symbol = " ";
      # haskell.symbol = " ";
      # haxe.symbol = " ";
      # hg_branch.symbol = " ";
      # hostname.ssh_symbol = " ";
      # java.symbol = " ";
      # julia.symbol = " ";
      # kotlin.symbol = " ";
      # lua.symbol = " ";
      # memory_usage.symbol = "󰍛 ";
      # meson.symbol = "󰔷 ";
      # nim.symbol = "󰆥 ";
      # nix_shell.symbol = " ";
      # nodejs.symbol = " ";
      # ocaml.symbol = " ";
      os = {
        disabled = false;
        style = "bg:color_02 fg:color_05";
        symbols = {
          Alpaquita = "  ";
          Alpine = "  ";
          AlmaLinux = "  ";
          Amazon = "  ";
          Android = "  ";
          Arch = "  ";
          Artix = "  ";
          CachyOS = "  ";
          CentOS = "  ";
          Debian = "  ";
          DragonFly = "  ";
          Emscripten = "  ";
          EndeavourOS = "  ";
          Fedora = "  ";
          FreeBSD = "  ";
          Garuda = " 󰛓 ";
          Gentoo = "  ";
          HardenedBSD = " 󰞌 ";
          Illumos = " 󰈸 ";
          Kali = "  ";
          Linux = "  ";
          Mabox = "  ";
          Macos = "  ";
          Manjaro = "  ";
          Mariner = "  ";
          MidnightBSD = "  ";
          Mint = "  ";
          NetBSD = "  ";
          NixOS = "  ";
          Nobara = "  ";
          OpenBSD = " 󰈺 ";
          openSUSE = "  ";
          OracleLinux = " 󰌷 ";
          Pop = "  ";
          Raspbian = "  ";
          Redhat = "  ";
          RedHatEnterprise = "  ";
          RockyLinux = "  ";
          Redox = " 󰀘 ";
          Solus = " 󰠳 ";
          SUSE = "  ";
          Ubuntu = "  ";
          Unknown = "  ";
          Void = "  ";
          Windows = " 󰍲 ";
          };
      };
      # package.symbol = "󰏗 ";
      # perl.symbol = " ";
      # php.symbol = " ";
      # pijul_channel.symbol = " ";
      # python.symbol = " ";
      # rlang.symbol = "󰟔 ";
      # ruby.symbol = " ";
      # rust.symbol = "󱘗 ";
      # scala.symbol = " ";
      # swift.symbol = " ";
      # zig.symbol = " ";
      # gradle.symbol = " ";

      fill = {
        style = "fg:color_02";
        symbol = "·";
      };

      username = {
        show_always = false;
        style_user = "bg:color_03 fg:color_05";
        style_root = "bg:color_03 fg:color_05";
        format = "[ $user ]($style)";
      };

      c = {
        symbol = " ";
        inherit (lang) style format;
      };

      docker_context = {
        symbol = " ";
        inherit (container) style format;
      };

      elixir = {
        symbol = " ";
        inherit (lang) style format;
      };

      elm = {
        symbol = " ";
        inherit (lang) style format;
      };

      git_branch = {
        symbol = "";
        inherit (git) style;
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        inherit (git) style format;
        # format = "[[($all_status$ahead_behind )](fg:color_02 bg:color_11)]($style)";
      };

      golang = {
        symbol = " ";
        inherit (lang) style format;
      };

      haskell = {
        symbol = " ";
        inherit (lang) style format;
      };

      java = {
        symbol = " ";
        inherit (lang) style format;
      };

      julia = {
        symbol = " ";
        inherit (lang) style format;
      };

      nodejs = {
        symbol = "";
        inherit (lang) style format;
      };

      nim = {
        symbol = " ";
        inherit (lang) style format;
      };

      nix_shell = {
        symbol = "";
        inherit (container) style format;
      };

      python = {
        inherit (lang) style format;
        # format = "[(\($virtualenv\) )]($style)";
      };

      rust = {
        symbol = "";
        inherit (lang) style format;
      };

      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:color_02";
        format = "[[  $time ](fg:color_10 bg:color_02)]($style)";
      };

      line_break = {
        disabled = false;
      };

      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:color_11)";
        error_symbol = "[❯](bold fg:color_08)";
        vimcmd_symbol = "[❮](bold fg:color_09)";
        vimcmd_replace_one_symbol = "[❮](bold fg:color_14)";
        vimcmd_replace_symbol = "[❮](bold fg:color_14)";
        vimcmd_visual_symbol = "[❮](bold fg:color_13)";
      };
    };
  };
}
