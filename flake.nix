{
  description = "Advent of Code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = let
	pkgs = import nixpkgs { inherit system; };
	opkgs = pkgs.ocamlPackages;
      in
	pkgs.mkShell {
	  packages = [
	    pkgs.nixfmt
	    pkgs.nil
	    pkgs.ocaml
	    pkgs.dune_3
	    pkgs.ocamlformat
	    pkgs.fswatch
	    opkgs.odoc
	    opkgs.ocaml-lsp
	    opkgs.ocamlformat-rpc-lib
	    opkgs.utop
	  ];
	};
    });
}
