{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs =
          import nixpkgs {
            inherit system;
            overlays = [ devshell.overlays.default ];
          };
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-basic amsfonts beamer babel-german tcolorbox emoji environ
            ccicons csquotes csvsimple doclicense fancyvrb fontspec gobble
            koma-script ifmtarg latexmk lm markdown mathtools minted noto
            nunito pgf relsize soul unicode-math lualatex-math gitinfo2
            eso-pic biblatex biblatex-trad biblatex-software xkeyval xurl
            xifthen biber;
        };

      in
      {
        devShells.default = (pkgs.devshell.mkShell {
          imports = [ "${devshell}/extra/git/hooks.nix" ];
          name = "itSec-seminar-talk-shell";
          packages = with pkgs; [ tex nixpkgs-fmt nodePackages.prettier ];
          git.hooks = {
            enable = true;
            pre-commit.text = ''
              nix flake check
            '';
          };
          commands = [
            {
              name = "build";
              command = ''
                latexmk
              '';
              help = "build the slides";
            }
            {
              name = "clean";
              command = ''
                latexmk -c
              '';
              help = "build the slides";
            }
          ];
        });

        checks = {
          nixpkgs-fmt = pkgs.runCommand "check-nixpkgs-fmt"
            { nativeBuildInputs = [ pkgs.nixpkgs-fmt ]; } ''
            nixpkgs-fmt --check ${./.} && touch $out
          '';
          prettier-check = pkgs.runCommand "check-with-prettier"
            { nativeBuildInputs = [ pkgs.nodePackages.prettier ]; } ''
            cd ${./.} && prettier --check . && touch $out
          '';
        };
      }
    );
}
