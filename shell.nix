{ pkgs ? import <nixpkgs> {config.allowUnfree = true;} }:pkgs.mkShell {
  packages = with pkgs; [
    firecracker
    gh
    gnumake
    go-task
    linux-scripts
    squashfsTools
  ];
}