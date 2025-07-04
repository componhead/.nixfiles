# https://primamateria.github.io/blog/neovim-nix/
{ pkgs }:
let
  customRC = import ./config { inherit pkgs; };
in
  pkgs.wrapNeovim pkgs.neovim {
      configure = {
        inherit customRC;
      };
    }
