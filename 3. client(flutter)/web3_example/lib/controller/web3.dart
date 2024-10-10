import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Web3Datasource {
  late Web3Client _client;
  static const String _rpcUrl =
      "http://127.0.0.1:8545"; // RpcUrl from hardhat.config.js
  static const String _ownerPrivateKey =
      "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"; // Start Node, You can find Private key (#0)
  static const String _privateKey =
      '0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d'; // #1

  Web3Datasource() {
    initialize();
  }

  void initialize() {
    _client = Web3Client(_rpcUrl, Client());
  }

  EthPrivateKey get owner => EthPrivateKey.fromHex(_ownerPrivateKey);

  EthPrivateKey get contributor => EthPrivateKey.fromHex(_privateKey);

  Web3Client get client => _client;
}
