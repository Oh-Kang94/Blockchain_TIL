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
```

#### 2. require vs Assert

- 1. require : 외부 입력값에 대한 평가를 하고, 에러를 발생시킨다면 Gas를 환불한다.

- 2. assert : Panic(`uint256`)의 에러를 발생시키고, 가스를 소비한다.

<details>
    <Summary>Example for use require And Assert</Summary>
<pre>

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Sharer {
    function sendHalf(address payable addr) public payable returns (uint balance) {
        require(msg.value % 2 == 0, "Even value required.");
        uint balanceBeforeTransfer = address(this).balance;
        addr.transfer(msg.value / 2);
        // Since transfer throws an exception on failure and
        // cannot call back here, there should be no way for us to
        // still have half of the money.
        assert(address(this).balance == balanceBeforeTransfer - msg.value / 2);
        return address(this).balance;
    }
}

```

</pre>

</details>
