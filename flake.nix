{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    saronic.url = "git+ssh://git@github.com/saronic-technologies/prototype-software-merry";
  };
  outputs = { nixpkgs, saronic, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    rec {
      devShell = saronic.devShells.${system}.no-step;
   }
  );
}

