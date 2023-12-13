{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      pymap3d = pkgs.python3Packages.buildPythonPackage rec {
        pname = "pymap3d";
	version = "3.0.1";
	format = "pyproject";
	src = pkgs.fetchFromGitHub {
	  #https://github.com/geospace-code/pymap3d
	  owner = "geospace-code";
	  repo = "pymap3d";
	  rev = "81172e221a4c9884450a38ec8a7ee382198cb7e3";
	  hash = "sha256-iyHlBGuECE8GH1eWFh+LwYsNYy0isl57gJAL4E45XBo=";
	};
	nativeBuildInputs = with pkgs.python3Packages; [ setuptools ];
	doCheck = false;
      };
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          (python3.withPackages(ps: with ps; [
            ipython
            jupyter
            numpy
            pandas
	    scikit-learn
	    matplotlib
	    seaborn
	    pymap3d
	    plotly
	    (opencv4.override { enableGtk2 = true; })
          ]))
        ];
        shellHook = "jupyter notebook";
      };
    }
  );
}
