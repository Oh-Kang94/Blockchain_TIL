State Management : Riverpod

Architecture : Clean Architecture

Router : Go Router

DI : Get_it

Local DB : Isar, Shared Preference

Model : Freezed

Environment : Flavor(Custom) => Localhost, TestNet

Network Client : Dio, Web3Dart, http

# 1. How to Run (Node(Localhost))

- Please, kindly check `4. nft_practice` and run belows for using localhost Node.

## 1. Add Dependencies (You Need Node Runtime)

```zsh
    npm install -D hardhat
    npm install -D @nomicfoundation/hardhat-toolbox
```

## 2. Compile The Contract

In this project, we will need the NftSaleable.sol

```zsh
    npx hardhat compile
```

## 3. Run the Node

```zsh
    npx hardhat node
```

## 4. Ignite the Compiled

```zsh
    npx hardhat ignition deploy ./ignition/modules/NftSaleable.ts --network localhost
```

## Done!

# 2. How to Run (Client)

## 1. Add a Dependencies

```sh
    flutter pub get
```

## 2. Generate Code

```zsh
    dart run build_runner build --delete-conflicting-outputs
```

or

```zsh
    sh ./scripts/build_runner.sh
```

### 3. Setting run env (if you use VS Code)

please, Copy `./scripts/launch.json` to Your local `launch.json`

### 4. Run this code Via VS Code Debugger

If you run via localhost environment, Please, Do Run Node(localhost) first.

Please, kindly check first Section [How to Run (Node(Localhost))](<#1.-How-to-Run-(Node(Localhost))>)

Also, If you want to run in testnet Environment, You should deploy in your test code
And, you should write your env in `.env.test`

Example )

```.env.test
    apiKey = 'YOUR_API_KEY'

    rpcUrl = 'YOUR_DEPLOYED_RPC_URL'

    chainId = 'YOUR_DEPLOYED_CHAIN_ID'

    contractAddress = 'YOUR_DEPLOYED_CONTRACT_ADDRESS_FROM_YOUR_TESTNET'

    db_path = testnet

```
