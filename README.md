# PQC Wireguard as a new VPN
IT-Security Seminar Talk

> [!IMPORTANT]
> The code to generate the presentation Slide has been forked from [rosenpass/slides](https://github.com/rosenpass/slides). \
> ⚠️ All rights to the retained assets, template & resources to them. ⚠️

## Contents
  2024-01-18-talk / [Slides](./2024-01-18-talk/slides.pdf) \
  2024-03-31-paper / [mini Paper](./2024-03-31-paper/paper.pdf)

## Shell
To generate the PDFs during editing, ensure that you have *Nix* installed on your system.
Run the following command in the directory that you are editing:
```sh
$ nix develop --extra-experimental-features "flakes nix-command"
```

## Make
compile the final product by running the following command with "${FOLDER}" replaced by the name of the directory:
```sh
$ nix build .#packages.x86_64-linux.${FOLDER_NAME} --extra-experimental-features "flakes nix-command"
```
