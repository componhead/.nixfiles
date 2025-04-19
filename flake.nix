{
	description = "Colossus Flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.11";
		# nix-darwin = {
		# 	url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
		# };
	};

	outputs = { self, nixpkgs, ... }:
		let
			lib = nixpkgs.lib;
		in {
		nixosConfigurations = {
			colossus = lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./configuration.nix ];
			};
		};
	};

}
