{ inputs, config, lib, pkgs, ... }:

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
	#home.file.".emacs.d".source = ./dotfiles/emacs;

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
		unzip
		spotify
		jq
  		postman
		jujutsu
		eza
		fzf
		nerd-fonts.jetbrains-mono
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
        ];

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
		];
	};

	programs.zoxide = {
		enable = true;
		enableZshIntegration = true;
	};

	programs.zsh = {
		enable = true;
		autosuggestion.enable = true;
		syntaxHighlighting = {
			enable = true;
		};
		shellAliases = {
			rebuild = "sudo nixos-rebuild switch --flake ~/nixos --impure";
		};
		envExtra = ''
			export ANDROID_HOME="~/Android/Sdk"
			export PATH="$HOME/Android/Sdk/platform-tools/:$PATH"
			'';

	};

	programs.zen-browser = {
		enable = true;
	};

	programs.starship.enable = true;

	home.stateVersion = "25.05";

	programs.home-manager.enable = true;
	
}  
