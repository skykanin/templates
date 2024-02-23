{
  description = "Dev environment template for <PROJECT>";

  inputs = {
    # Nix package set
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system: function nixpkgs.legacyPackages.${system});
  in {
    devShells = forAllSystems (pkgs: {
      # A Haskell development environment with provided tooling
      default = let
        # The compiler version to use for development
        compiler-version = "ghc948";
        inherit (pkgs) lib;
        hpkgs = pkgs.haskell.packages.${compiler-version};
        # Haskell library functions
        hlib = pkgs.haskell.lib;
        # Haskell and shell tooling
        tools = with hpkgs; [
          haskell-language-server
          ghc
          cabal-install
          # cabal-plan
          (hlib.dontCheck ghcid)
          (hlib.dontCheck fourmolu)
        ];
        # System libraries that need to be symlinked
        libraries = with pkgs; [zlib];
        libraryPath = "${lib.makeLibraryPath libraries}";
      in
        hpkgs.shellFor {
          name = "dev-shell";
          packages = p: [];
          withHoogle = false;
          buildInputs = tools ++ libraries;

          LD_LIBRARY_PATH = libraryPath;
          LIBRARY_PATH = libraryPath;
        };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    nixConfig = {
      # Configure cachix cache as chosen GHC version is not cached in nixpkgs
      extra-substituers = ["https://haskell-dev-shell.cachix.org"];
      extra-trusted-public-keys = ["haskell-dev-shell.cachix.org-1:drFpU0pMVRoyEj4VXocwIvycjEEY6z5Hh18CrkVz+ZM="];
    };
  };
}
