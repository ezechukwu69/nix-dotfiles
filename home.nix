{ inputs, config, lib, pkgs, customPkgs, ... }:

{
  imports = [inputs.zen-browser.homeModules.twilight];
  home.username = "ezechukwu69";
  home.homeDirectory = "/home/ezechukwu69";

  xdg.configFile."emacs".source = ./dotfiles/emacs;
  xdg.configFile."kanata".source = ./dotfiles/kanata;
  xdg.configFile."hypr".source = ./dotfiles/hypr;
  xdg.configFile."waybar".source = ./dotfiles/waybar;
  xdg.configFile."matugen".source = ./dotfiles/matugen;
  xdg.configFile."waypaper".source = ./dotfiles/waypaper;
  xdg.configFile."hyprpanel".source = ./dotfiles/hyprpanel;
  xdg.configFile."nvim".source = ./dotfiles/nvim-fnl;
  xdg.configFile."jj".source = ./dotfiles/jj;
#home.file.".emacs.d".source = ./dotfiles/emacs;


  home.sessionVariables = {
    XKB_CONFIG_ROOT="${pkgs.xkeyboard-config}/share/X11/xkb";
    LD_LIBRARY_PATH = "${
      with pkgs;
      lib.makeLibraryPath [ 
        glibc
        protobuf
        xorg.libX11
        fontconfig
        freetype
        alsa-lib
        dbus
        openssl
        expat
        libbsd
        libpulseaudio
        libuuid
        xorg.libxcb
        libxkbcommon
        xorg.xcbutilwm
        xorg.xcbutilrenderutil
        xorg.xcbutilkeysyms
        xorg.xcbutilimage
        xorg.xcbutilcursor
        xorg.libICE
        xorg.libSM
        xorg.libXi
        xorg.libxkbfile
        xorg.libXext
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXfixes
        libGL
        libdrm
        libpng
        nspr
        nss_latest
        systemd
        wayland
        vulkan-headers
        vulkan-loader
      ]
    }:$LD_LIBRARY_PATH";
  };

  home.packages = with pkgs; [
      btop
      ripgrep
      vivaldi
      tree
      rofi
      albert
      zellij
      lazydocker
      neofetch
      zip
      delta
      meld
      unzip
      tailscale
      spotify
      jq
      postman
      jujutsu
      eza
      fzf
      prisma
      firebase-tools
      nerd-fonts.jetbrains-mono
      android-studio
      networkmanagerapplet
      jetbrains-toolbox
      flutter
      blueman
      nodejs_24
      sherlock-launcher
      aporetic
      gh
      waypaper
      swww
      ghostty
      helix
      zed-editor
      jdk23
      php
# language servers
      lua-language-server
      typescript-language-server
      vtsls
      phpactor
#end
      teamviewer
      ] ++ (with customPkgs; [
          vicinaeBin
      ]);

  dconf.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  programs.git = {
    enable = true;
    userName = "ezechukwu69";
    userEmail = "ezechukwu69@gmail.com";

    extraConfig = {
      credential = {
        helper = "store";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      corfu
        eat
        cargo
        vertico
        apheleia
        popon
        vterm
        cape
        dape
        keycast
        eldoc-box
        helpful
        all-the-icons-dired
        diredfl
        nerd-icons-corfu
        ibuffer-project
        exec-path-from-shell
        dirvish
        spacious-padding
        nix-mode
        toml-mode
        json-mode
        zig-mode
        yaml-mode
        lua-mode
        rust-mode
        treesit-auto
        php-mode
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
    };
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos --impure";
      # nvim = "bob run nightly";
      ze = "gtk-launch dev.zed.Zed-Preview.desktop";
    };
    envExtra = ''
      #if [[ ! -d "$HOME/.fzf-tab" ]]; then
      #  ${pkgs.git}/bin/git clone https://github.com/Aloxaf/fzf-tab.git "$HOME/.fzf-tab"
      #fi
      #source "$HOME/.fzf-tab/fzf-tab.plugin.zsh"
      #zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word'
      #zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always --oneline --graph $word'
      #zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -la $realpath'
      #zstyle ':fzf-tab:*' fzf-flags '--height=80%' '--layout=reverse'
      mkdir -p ~/.npm-global
      npm config set prefix '~/.npm-global'
      zstyle ':completion:*' menu select interactive
      setopt AUTO_MENU
      setopt MENU_COMPLETE
      export ANDROID_HOME="~/Android/Sdk"
      export PATH="$HOME/Android/Sdk/platform-tools/:$PATH"
      export PATH="$HOME/.cargo/bin/:$PATH"
      export PATH="$PATH":"$HOME/.pub-cache/bin"
      export PATH="$PATH":"$HOME/.npm-global/bin"
      export PATH="$HOME/.local/bin":"$PATH"
      export PRISMA_QUERY_ENGINE_LIBRARY=${pkgs.prisma-engines}/lib/libquery_engine.node
      export PRISMA_QUERY_ENGINE_BINARY=${pkgs.prisma-engines}/bin/query-engine
      export PRISMA_SCHEMA_ENGINE_BINARY=${pkgs.prisma-engines}/bin/schema-engine
      . ~/.local/share/bob/env/env.sh
    '';

  };

  programs.zen-browser = {
    enable = true;
  };

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

}  
