{ config, pkgs, ... }:

{
	home.username = "ezechukwu69";
	home.homeDirectory = "/home/ezechukwu69";

	xdg.configFile."emacs".source = ./dotfiles/emacs;
	xdg.configFile."kanata".source = ./dotfiles/kanata;
	xdg.configFile."hypr".source = ./dotfiles/hypr;
	xdg.configFile."waybar".source = ./dotfiles/waybar;
	xdg.configFile."matugen".source = ./dotfiles/matugen;
	#home.file.".emacs.d".source = ./dotfiles/emacs;

	home.packages = with pkgs; [
		btop
 		ripgrep
		tree
		neofetch
		zip
		unzip
		jq
		eza
		fzf
		gh
  		ghostty
        ];

	programs.git = {
		enable = true;
		userName = "ezechukwu69";
		userEmail = "ezechukwu69@gmail.com";
	};

	programs.emacs = {
		enable = true;
	};

	programs.zsh = {
		enable = true;
	};

	programs.starship.enable = true;

	home.stateVersion = "25.05";

	programs.home-manager.enable = true;
	
}  
