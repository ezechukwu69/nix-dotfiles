{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    mise
    gnumake
    zlib
    libffi
    libyaml
    pkg-config
  ];

  shellHook = ''
    echo "Welcome to the Nix development shell!"
    # Any custom commands or environment variable settings
  '';
}
