{
	description = "Colossus Flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.11";
		home-manager.url = "github:nix-community/home-manager/release-24.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		# nix-darwin = {
		# 	url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
		# };
	};

	outputs = { self, nixpkgs, home-manager, ... }:
		let
			lib = nixpkgs.lib;
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			nixosConfigurations = {
				colossus = lib.nixosSystem {
					inherit system;
					modules = [ ./configuration.nix ];
				};
			};
			homeConfigurations = {
				emi = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					modules = [ ./home.nix ];
				};
			};
		};

}
