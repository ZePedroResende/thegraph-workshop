# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {

        devShell = with pkgs; mkShell {
          buildInputs = [
            yarn
            nodejs-16_x
          ];

          # Decorative prompt override so we know when we're in a dev shell
          shellHook = ''
            export PS1="\e[1;33m\][dev]\e[1;34m\] \w $ \e[0m\]"
          '';
        };
      });
}
