let
  channel = "nixos-20.09";
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  name = "terraform-google-minecraft";
  buildInputs = [
    pkgs.cue
    pkgs.terraform_0_14
    pkgs.google-cloud-sdk
    pkgs.python38Packages.pre-commit
    pkgs.tflint
  ];
}
