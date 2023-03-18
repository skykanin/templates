{
  description = "Basic dev environment template";

  inputs = {
    # Unofficial library of utilities for managing Nix Flakes.
    flake-utils.url = "github:numtide/flake-utils";

    # Nix package set
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem
    (system: {
      devShells.default =
        let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (pkgs) lib;
          tools = with pkgs; [];
          libraries = with pkgs; [ zlib ];
          libraryPath = "${lib.makeLibraryPath libraries}";
        in pkgs.mkShell {
          name = "dev-shell";
          buildInputs = tools ++ libraries;

          LD_LIBRARY_PATH = libraryPath;
          LIBRARY_PATH = libraryPath;
        };
    });
}
