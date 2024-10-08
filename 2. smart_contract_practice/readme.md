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

### ETC

#### 1. .gitignore

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
