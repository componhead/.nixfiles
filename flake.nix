{
	description = "Componhead Flake";

	inputs = {
    		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		neovim = {
			url = "github:nix-community/neovim-nightly-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs @ { self, nixpkgs, home-manager, neovim, ... }:
		let
			lib = nixpkgs.lib;
			system = "x86_64-linux";
			defaultPackageName = "nvim";
			overlayFlakeInputs = prev: final: {
				neovim = neovim.packages.${system}.neovim;
			};
			overlayMyNeovim = prev: final: {
				myNeovim = import ./packages/vim/myNeovim.nix {
					pkgs = final;
				};
			};
			pkgs = import nixpkgs {
				overlays = [ overlayFlakeInputs overlayMyNeovim ];
			};

		in {
			nixpkgs.config.allowUnfree = true;
			packages.${system}.default = neovim.packages.${system}.neovim;
			# apps.${system}.default = {
			# 	type = "app";
			# 	program = "${neovim.packages.x86_64-linux.neovim}/bin/nvim";
			# };
			nixosConfigurations = {
				colossus = let
					username = "emi";
					specialArgs = { inherit nixpkgs; };
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
						];
					};
			};
		};

}
