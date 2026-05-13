{
  description = "Helium browser flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system}.helium = pkgs.callPackage ./pkgs/helium.nix { };

      # packages.${system}.default = self.packages.${system}.helium;

      apps.${system}.helium = {
        type = "app";
        program = "${self.packages.${system}.helium}/bin/helium";
      };

      # apps.${system}.default = self.apps.${system}.helium;
    };
}
