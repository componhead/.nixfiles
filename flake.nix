{
	description = "Componhead Flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
		home-manager.url = "github:nix-community/home-manager/release-24.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs @ { self, nixpkgs, home-manager, ... }:
		let
			lib = nixpkgs.lib;
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			nixpkgs.config.allowUnfree = true;
			nixosConfigurations = {
				colossus = let
					username = "emi";
					specialArgs = { inherit system; };
				in
					lib.nixosSystem {
						inherit specialArgs;
						modules = [
							./configuration.nix
							home-manager.nixosModules.home-manager
            						{
            							home-manager.useGlobalPkgs = true;
            							home-manager.useUserPackages = true;

            							home-manager.extraSpecialArgs = inputs // specialArgs;
            							home-manager.users.${username} = import ./home.nix;
            						}
							({pkgs, ... }: {
								programs.neovim.defaultEditor = true;
							})
						];
					};
			};
		};

}
