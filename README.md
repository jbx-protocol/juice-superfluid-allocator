# Juice Extension Templates

This repo provides some implementation templates of peripheral contracts of the Juicebox V2 ecosystem.

# Install Foundry

To get set up:

1. Install [Foundry](https://github.com/gakonst/foundry).

```bash
curl -L https://foundry.paradigm.xyz | sh
```

2. Install external lib(s)

```bash
git submodule update --init && yarn install
```

then run

```bash
forge update
```

If git modules are failing to clone, not installing, etc (ie overall submodule misbehaving), use `git submodule update --init --recursive --force`

3. Run tests:

```bash
forge test
```

4. Update Foundry periodically:

```bash
foundryup
```

## Content

This repo is organised as follow:

- contracts/Allocator: contains an IJBSplitsAllocator implementation template (Allocator.sol)

- contracts/DatasourceDelegate: contains an IJBFundingCycleDataSource, IJBPayDelegate and IJBRedemptionDelegate implementation templates (DataSourceDelegate.sol).

- contracts/Terminal: contains an IJBPaymentTerminal and IJBRedemptionTerminal implementation template.

# Deploy & verify

#### Setup

Configure the .env variables, and add a mnemonic.txt file with the mnemonic of the deployer wallet. The sender address in the .env must correspond to the mnemonic account.

## Rinkeby

```bash
yarn deploy-rinkeby
```

## Mainnet

```bash
yarn deploy-mainnet
```

The deployments are stored in ./broadcast

See the [Foundry Book for available options](https://book.getfoundry.sh/reference/forge/forge-create.html).
