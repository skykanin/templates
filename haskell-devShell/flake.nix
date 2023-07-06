{
  description = "Dev environment template for <PROJECT>";

  inputs = {
    # Unofficial library of utilities for managing Nix Flakes.
    flake-utils.url = "github:numtide/flake-utils";

    # Nix package set
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachSystem
    (with flake-utils.lib.system; [ x86_64-linux x86_64-darwin aarch64-darwin ])
    (system: {
      # A Haskell development environment with provided tooling
      devShells.default =
        let
          # The compiler version to use for development
          compiler-version = "ghc945";
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (pkgs) lib;
          hpkgs = pkgs.haskell.packages.${compiler-version};
          # Haskell library functions
          hlib = pkgs.haskell.lib;
          # Haskell and shell tooling
          tools = with hpkgs; [
            haskell-language-server
            ghc
            cabal-install
            cabal-plan
            (hlib.dontCheck ghcid)
            (hlib.dontCheck fourmolu)
          ];
          # System libraries that need to be symlinked
          libraries = with pkgs; [ zlib ];
          libraryPath = "${lib.makeLibraryPath libraries}";
        in hpkgs.shellFor {
          name = "dev-shell";
          packages = p: [ ];
          withHoogle = false;
          buildInputs = tools ++ libraries;

          LD_LIBRARY_PATH = libraryPath;
          LIBRARY_PATH = libraryPath;
        };
    }) // {
    nixConfig = {
      # Configure cachix cache as chosen GHC version is not cached in nixpkgs
      extra-substituers = [ "https://haskell-dev-shell.cachix.org" ];
      extra-trusted-public-keys = [ "haskell-dev-shell.cachix.org-1:drFpU0pMVRoyEj4VXocwIvycjEEY6z5Hh18CrkVz+ZM=" ];
    };
  };
}
