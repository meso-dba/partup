{
  description = "Partup Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system} = {
        partup = pkgs.stdenv.mkDerivation {
          pname = "partup";
          version = "v3.0.0";

          src = pkgs.fetchFromGitHub {
            owner = "meso-dba";
            repo = "partup";
            rev = "3a748e413dd4b6e40398b5fd2df06b514ff843e1";
            sha256 = "sha256-tefDDVQ3195nNiMrmlBXqAY07zxACgr24TRAwCjqqYY=";
          };

          nativeBuildInputs = [
            pkgs.meson
            pkgs.ninja
            pkgs.pkg-config
          ];

          buildInputs = [
            pkgs.glib
            pkgs.libyaml
            pkgs.parted
            pkgs.util-linux
            pkgs.squashfsTools
            pkgs.dosfstools
            pkgs.e2fsprogs
            pkgs.mtdutils
            pkgs.python3
            pkgs.python3Packages.virtualenv
          ];

          NIX_CFLAGS_COMPILE = "-D_POSIX_C_SOURCE=200809L";
          doCheck = false;
        };

        default = self.packages.${system}.partup;
      };
    };
}
