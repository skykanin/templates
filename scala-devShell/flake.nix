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
    (with flake-utils.lib.system; [ x86_64-linux aarch64-linux x86_64-darwin aarch64-darwin ])
    (system: {
      # A Scala development environment with provided tooling
      devShells.default =
        let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (pkgs) lib;
          # Scala and shell tooling
          tools = with pkgs; [
            binutils-unwrapped
            metals
            # Scala 3 compiler
            dotty
            sbt
            scalafmt
            scalafix
          ];
          # System libraries that need to be symlinked
          libraries = [ ];
          libraryPath = "${lib.makeLibraryPath libraries}";
        in pkgs.mkShell {
          name = "dev-shell";
          packages = tools ++ libraries;

          LD_LIBRARY_PATH = libraryPath;
          LIBRARY_PATH = libraryPath;
        };
    });
}
