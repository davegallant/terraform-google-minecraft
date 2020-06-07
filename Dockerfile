FROM nixos/nix

ARG LOCAL_UID=1000

WORKDIR /home/nix
RUN chown ${LOCAL_UID}:${LOCAL_UID} /home/nix

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
RUN nix-channel --update

RUN nix-env -iA nixpkgs.terraform
RUN nix-env -iA nixpkgs.google-cloud-sdk
