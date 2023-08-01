# Move Demo App

This is a demo move + nextjs app to create + update a non-unique name for your address

## Tooling

- IntelliJ CE + Move plugin works really well (and free!)
- [`aptos CLI`](https://github.com/aptos-labs/aptos-core/releases) lets us create/manage accounts, compile/test/deploy move code
- NodeJS + yarn for web dev
- VSCode generally pretty good for web dev

Optionally, [nix](https://nixos.org/download.html) for Aptos CLI and web dev tools with the `shell.nix` file in this project

## Directory structure

Move code: `./move_demo`
Website code: `./app`

## Commands

Create an Aptos account

```
aptos init --profile <profile-name>
```

Compile the Move code

```
aptos move compile --package-dir move_demo --named-addresses move_demo=<profile-account>

# or

aptos move compile --package-dir move_demo --named-addresses move_demo=0x$(aptos config show-profiles | jq -r '.Result.<profile-name>.account')
```

Publish the Move code

```
aptos move publish --package-dir move_demo --named-addresses move_demo=<profile-account>

# or

aptos move publish --package-dir move_demo --named-addresses move_demo=0x$(aptos config show-profiles | jq -r '.Result.<profile-name>.account') --profile=<profile-name>
```

Running the web app

```
cd app
yarn
yarn dev
# Try opening localhost:3000 in your browser now
```

## Notes
- package::module::{type|function}. package is an alias for the address
- compiled code can be found in `build/` dir
- dependencies can be found in `~/.move`. Sometimes nuking this directory can help fix bad dependencies
- deployed code can be interacted with on the explorer
- upgrades are possible with `compatible` as long as public function signatures don't change and existing move structs don't change

- browser wallets simply inject into global scope (see `petra` in console)
- @aptos-labs/aptos-wallet-adapter-react allows us to use different abstracted wallet adapters via a simple interface
- `AptosClient` is available both on browser + NodeJS. This package is a wrapper around the [Aptos node API](https://fullnode.devnet.aptoslabs.com/v1/spec#/) and lets us query for blockchain info and submit transactions

## TODO

- [ ] `./app` is heavily borrowed from the aptos-wallet-adapter demo app. This web project can be greatly simplified for easier future use
