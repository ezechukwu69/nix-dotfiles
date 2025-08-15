{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      #/release-25.05
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = { 
	    url = "github:0xc000022070/zen-browser-flake";
	    inputs.nixpkgs.follows = "nixpkgs";
	    inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, lanzaboote, ... }: {
	nixosConfigurations.stemzzz = nixpkgs.lib.nixosSystem {
		modules = [ 
			lanzaboote.nixosModules.lanzaboote
			./configuration.nix 
			home-manager.nixosModules.home-manager
			{
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
				home-manager.backupFileExtension = "backup";
				home-manager.extraSpecialArgs = { inherit inputs; };
				home-manager.users.ezechukwu69 = import ./home.nix;
			}
		];
	};
  };
}
