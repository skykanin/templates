{
  description = "Basic dev environment template";

  inputs = {
    # Nix package set
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      default = let
        inherit (pkgs) lib;
        tools = with pkgs; [];
        libraries = with pkgs; [zlib];
        libraryPath = "${lib.makeLibraryPath libraries}";
      in
        pkgs.mkShell {
          name = "dev-shell";
          buildInputs = tools ++ libraries;

          LD_LIBRARY_PATH = libraryPath;
          LIBRARY_PATH = libraryPath;
        };
    });
    formatter = forAllSystems (pkgs: pkgs.alejandra);
  };
}
