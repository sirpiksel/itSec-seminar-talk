# PQC Wireguard as a new VPN
IT-Security Seminar Talk

> [!IMPORTANT]
> The code to generate the presentation Slide has been forked from [rosenpass/slides](https://github.com/rosenpass/slides). \
> ⚠️ All rights to the retained assets, template & resources to them. ⚠️

## Abstract
With the advance of quantum computers security researchers face the challenge of securing their data against *"Harvest now, decrypt later"-attacks* that could become available in the future. Shor's algorithm, when implemented on a sufficiently powerfull quantum computer, could be used to break many public-key cryptography schemes. Rosenpass aims to provide a *post-quantum-secure authenticated key exchange* that works in a *hybrid post-quantum security scheme* together with Wireguard. Due to the ongoing development of Post-quantum-Ciphers Rosenpass is implemented to provide hybrid post-quantum security in tandem with Wireguard.


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
