{ stdenv, fetchurl, lib, unzip }:

let
  os =
    if stdenv.isDarwin then "MacOSX"
    else if stdenv.isLinux then "Ubuntu"
    else throw "Unsupported platform ${stdenv.system}";

  sha256 = if os == "MacOSX" then "d0d24d69ec016182035eada0b7b4bf02468489f9d48a8e5b382f347b2a514a25"
            else "1f0ed0d0e042ff8b48b428eaaff9f52e6ff2b246a2054740d017f514c753c6cb";

in stdenv.mkDerivation rec {
  pname = "aptos-cli";
  version = "2.0.2";

  src = fetchurl {
    url = "https://github.com/aptos-labs/aptos-core/releases/download/${pname}-v${version}/${pname}-${version}-${os}-x86_64.zip";
    sha256 = sha256;
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp aptos $out/bin/aptos
  '';

  meta = with lib; {
    description = "Aptos CLI";
    homepage = "https://github.com/aptos-labs/aptos-core";
    platforms = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
  };
}
