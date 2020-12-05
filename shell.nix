let
  channel = "nixos-20.09";
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  name = "terraform-google-minecraft";
  buildInputs = [
    pkgs.terraform_0_13
    pkgs.google-cloud-sdk
    pkgs.python38Packages.pre-commit
    pkgs.tflint
  ];
}
