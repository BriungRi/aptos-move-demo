with import <nixpkgs> { };

pkgs.mkShell {
  buildInputs = [
    pkg-config
    rustc
    cargo
    rustfmt
    llvmPackages_12.llvm
    llvmPackages_12.clang
    openssl_1_1
    jq
    (callPackage ./aptos.nix { })
  ] ++ (
    lib.optional stdenv.isDarwin([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ SystemConfiguration ])
    )
  );
  LD_LIBRARY_PATH = "${lib.getLib openssl_1_1}/lib";

  shellHook = ''
    # Create or override the account
    alias gen="aptos init --profile move_demo"

    # Fund the account
    faucet() {
        aptos account fund-with-faucet --account 0x$(aptos config show-profiles | jq -r '.Result.move_demo.account')
    }

    # Compile the contracts
    compile() {
        aptos move compile --package-dir move_demo --named-addresses move_demo=0x$(aptos config show-profiles | jq -r '.Result.move_demo.account')
    }

    # Test the contracts
    test() {
        aptos move test --package-dir move_demo --named-addresses move_demo=0x$(aptos config show-profiles | jq -r '.Result.move_demo.account')
    }

    # Publish the contracts
    pub() {
        aptos move publish --package-dir move_demo --named-addresses move_demo=0x$(aptos config show-profiles | jq -r '.Result.move_demo.account') --profile=move_demo
    }
  '';
}
