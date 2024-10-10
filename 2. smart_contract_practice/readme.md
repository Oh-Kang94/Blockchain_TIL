# HardHat Study

## HardHat Deploy

### install

```bash
    npm install -D hardhat
    npm install -D @nomicfoundation/hardhat-toolbox
```

```bash
    npx hardhat init
    # After this Select "Create an empty hardhat.config.js"
```

in `hardhat.config.js`

```javascript
require("@nomicfoundation/hardhat-toolbox");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.0", // same as .sol version
};
```

<details>
    <summary>Structure</summary>
<pre>
    .
    ├── artifacts
    │   ├── build-info
    │   └── contracts
    ├── contracts
    │   └── fund_raising.sol
    ├── hardhat.config.js
    ├── package-lock.json
    ├── package.json
    ├── readme.md
    └── test
    └── fund_raising.js
</pre>

</details>

### run

#### 1. Do the Test

```bash
    # ./test
    npx hardhat test
```

#### 2. Make Network in LocalHost

```bash
    npx hardhat node
```

#### 3. Deploy in LocalHost

```bash
    # localhost는 "http://127.0.0.1:8545"로 config에서 지정
    npx hardhat ignition deploy ./ignition/modules/fund_raising.js --network localhost
```

### ETC

#### 1. .gitignore

<details>
    <summary>Detail</summary>
<pre>
   
```.gitignore
    # Hardhat files
    /cache
    /artifacts

    # TypeChain files
    /typechain
    /typechain-types

    # solidity-coverage files
    /coverage
    /coverage.json

    # Hardhat Ignition default folder for deployments against a local node
    ignition/deployments/chain-31337

```

</pre>
</details>
