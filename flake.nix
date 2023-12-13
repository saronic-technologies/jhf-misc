{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    saronic.url = "git+ssh://git@github.com/saronic-technologies/prototype-software-merry";
    jetpack-nixos.url = "github:anduril/jetpack-nixos";
  };
  outputs = { saronic, flake-utils, jetpack-nixos, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import saronic.inputs.nixpkgs {
        inherit system;
      };
      zed = saronic.packages.${system}.zed-sdk;
      l4t-cuda = if system == "aarch64-linux" then jetpack-nixos.legacyPackages.${system}.l4t-cuda else null;
      cuda = if system == "aarch64-linux" then jetpack-nixos.legacyPackages.${system}.cudaPackages.cudatoolkit else pkgs.cudaPackages.cudatoolkit;
    in
    rec {
      devShell = saronic.devShells.${system}.zeddy-rays.overrideAttrs (n: p: {
        buildInputs = p.buildInputs ++ [ zed ];
      });
      packages = rec {
        zepples = pkgs.stdenv.mkDerivation {
          name = "zepples";
          version = "0.0.1";
          src = ./export;
          cmakeFlags = [
            "-DZED_LIBRARY_DIR=${zed.out}/lib"
            "-DZED_LIBRARIES=${zed.out}/lib/libsl_zed.so"
          ];
          buildInputs = with pkgs; [
            cmake
            opencv4
            l4t-cuda
            cuda
            zed
            pkg-config
          ];
        };
      };
    }
  );
}

