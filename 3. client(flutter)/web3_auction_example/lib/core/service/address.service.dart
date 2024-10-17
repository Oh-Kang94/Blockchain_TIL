import 'package:web3dart/web3dart.dart';

abstract class AddressService {
  String generateMnemonic();
  Future<String> getPrivateKey(String mnemonic);
  Future<EthereumAddress> getPublicAddress(String privateKey);
  // Future<bool> setupFromMnemonic(String mnemonic);
  // Future<bool> setupFromPrivateKey(String privateKey);
  // String entropyToMnemonic(String entropyMnemonic);
}



// Ref: https://github.com/allanclempe/ether-wallet-flutter/