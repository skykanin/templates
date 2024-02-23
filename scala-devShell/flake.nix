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
      # A Scala development environment with provided tooling
      default = let
        inherit (pkgs) lib;
        # Scala and shell tooling
        tools = with pkgs; [
          binutils-unwrapped
          metals
          scala_3
          sbt
          scalafmt
          scalafix
        ];
        # System libraries that need to be symlinked
        libraries = [];
        libraryPath = "${lib.makeLibraryPath libraries}";
      in
        pkgs.mkShell {
          name = "dev-shell";
          packages = tools ++ libraries;

          LD_LIBRARY_PATH = libraryPath;
          LIBRARY_PATH = libraryPath;
        };
    });
    formatter = forAllSystems (pkgs: pkgs.alejandra);
  };
}
