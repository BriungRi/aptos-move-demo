with import <nixpkgs> { };

pkgs.mkShell {
  buildInputs = [
    nodejs-16_x
    nodePackages.pnpm
    yarn
    act
    nodePackages.firebase-tools
  ];

  shellHook = ''
  '';
}

