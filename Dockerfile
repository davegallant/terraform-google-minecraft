FROM nixos/nix

ARG LOCAL_UID=1000
WORKDIR /home/nix
RUN chown ${LOCAL_UID}:${LOCAL_UID} /home/nix
COPY default.nix /home/nix/
RUN nix-shell
ENTRYPOINT nix-shell
