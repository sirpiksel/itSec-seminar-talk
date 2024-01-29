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
          inherit (pkgs.texlive) scheme-basic
            babel-german babel-english amsfonts doclicense environ xkeyval lm
            beamer tcolorbox emoji ccicons csquotes csvsimple fancyvrb fontspec gobble koma-script ifmtarg latexmk markdown mathtools minted noto nunito pgf relsize soul unicode-math lualatex-math gitinfo2 eso-pic biblatex biblatex-trad biblatex-software xurl xifthen biber
            microtype booktabs amscls amsmath kastrup preprint caption comment cm-super cmap draftwatermark etoolbox fancyhdr float fontaxes geometry graphics hyperref hyperxmp iftex inconsolata libertine mmap ms mweights natbib ncctools newtx oberdiek refcount setspace textcase totpages trimspaces upquote url xcolor xstring luacode luatexbase txfonts;
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
                latexmk -c
                rm -f *.bbl *.cut
              '';
              help = "build the slides";
            }
            {
              name = "clean";
              command = ''
                latexmk -C
                rm -f *.bbl *.cut
              '';
              help = "remove temporary files";
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
