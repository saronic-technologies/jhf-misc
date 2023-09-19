{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    saronic.url = "git+ssh://git@github.com/saronic-technologies/prototype-software-merry";
  };
  outputs = { nixpkgs, saronic, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      gpsdclient = with pkgs.python3Packages; buildPythonPackage rec {
        pname = "gpsdclient";
        version = "1.3.2";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-cKSWVQqXR9/14OULPJWm4dyrnYQoYJl+lRIHZ+IGCno=";
        };
      };
      pyzed = saronic.packages.${system}.pyzed;
    in
    rec {
      devShell =
        let
          python = pkgs.python3;
          python-env = python.withPackages (ps: with ps; [
            cython
            numpy
            opencv4
            gpsdclient
	    pyzed
          ]);
        in
        pkgs.mkShell { buildInputs = [ python-env ]; };
    }
  );
}

