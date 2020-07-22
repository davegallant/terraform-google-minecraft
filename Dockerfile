FROM nixos/nix
RUN adduser nix --disabled-password
COPY shell.nix .
RUN nix-shell
RUN chown -R nix:nix /nix
USER nix
ENTRYPOINT nix-shell
