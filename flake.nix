{
  description = "A development environment for Godot 4";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = final: prev: {
          godot_4 = prev.godot_4.overrideAttrs (oldAttrs: {
            version = "4.2.1-stable";
            src = final.fetchurl {
              url = "https://downloads.tuxfamily.org/godotengine/4.2.1/godot-4.2.1-stable.tar.xz";
              sha256 = "vi1bgzNijpE13W/OmS69Fkgbl+mdb6zCKWQRp7f3KmI=";
              };
          });
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.godot_4 pkgs.git pkgs.zsh ];

          shellHook = ''
            if [ -z "$IN_NIX_SHELL_ZSH" ]; then
              export IN_NIX_SHELL_ZSH=1
              exec zsh
            else
              echo "Welcome to your Godot 4 development environment with Zsh!"
            fi
          '';
        };
      });
}
