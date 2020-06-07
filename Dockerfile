FROM nixos/nix

ARG LOCAL_UID=1000

WORKDIR /home/nix
RUN chown ${LOCAL_UID}:${LOCAL_UID} /home/nix

ENTRYPOINT nix-shell
