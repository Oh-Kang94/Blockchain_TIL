# Web3 Client

### This Client depends on `../2.smart_contract_practice` in `FundRaising`

## 1. Structure

    .
    ├── README.md
    ├── analysis_options.yaml
    ├── assets
    │   └── abi
    │       └── FundRaising.json
    ├── lib
    │   ├── controller
    │   │   ├── fundraising.dart
    │   │   └── web3.dart
    │   ├── datasource
    │   ├── main.dart
    │   └── pages
    │       └── home.dart
    ├── pubspec.lock
    ├── pubspec.yaml
    └── web3_example.iml

## 2. Call vs Transaction

### 1. Call

    단순하게 정보를 불러올때(Select) 쓰인다. Gas 비는 지불하지 않고, 그냥 정보를 불러올수만 있다.

### 2. Transaction

    Gas비가 소모되며, 어떠한 정보 Update, Create에 쓰인다.
