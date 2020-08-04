let
  channel = "nixos-20.03";
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  name = "terraform-google-minecraft";
  buildInputs = [
    pkgs.terraform_0_13
    pkgs.google-cloud-sdk
  ];
}
