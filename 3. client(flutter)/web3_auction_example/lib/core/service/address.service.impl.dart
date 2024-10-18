import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart';
// ignore: depend_on_referenced_packages
import 'package:hex/hex.dart' show HEX;
import 'package:web3_auction_example/core/service/address.service.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3dart/credentials.dart';

class AddressServiceImpl implements AddressService {
  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKey(String mnemonic) async {
    // 1. 니모닉에서 시드 생성
    final seed = bip39.mnemonicToSeed(mnemonic);

    // 2. BIP-32 마스터 키를 시드에서 생성
    final BIP32 root = BIP32.fromSeed(seed);

    // 3. 이더리움 표준 경로로 파생 경로 설정 (m/44'/60'/0'/0)
    final BIP32 child = root.derivePath("m/44'/60'/0'/0");

    // 4. 파생된 개인 키 가져오기
    final privateKey = HEX.encode(child.privateKey!);

    CLogger.i('private: $privateKey');

    return privateKey;
  }

  @override
  Future<EthereumAddress> getPublicAddress(String privateKey) async {
    CLogger.i('privateKey: $privateKey');
    CLogger.i('privateKey: ${privateKey.length}');
    final private = EthPrivateKey.fromHex(privateKey);

    CLogger.i('address: ${private.address}');

    return private.address;
  }

  // @override
  // Future<bool> setupFromMnemonic(String mnemonic) async {
  //   final cryptMnemonic = bip39.mnemonicToEntropy(mnemonic);
  //   final privateKey = await getPrivateKey(mnemonic);

  //   await _configService.setMnemonic(cryptMnemonic);
  //   await _configService.setPrivateKey(privateKey);
  //   await _configService.setupDone(true);
  //   return true;
  // }

  // @override
  // Future<bool> setupFromPrivateKey(String privateKey) async {
  //   await _configService.setMnemonic(null);
  //   await _configService.setPrivateKey(privateKey);
  //   await _configService.setupDone(true);
  //   return true;
  // }

  // @override
  // String entropyToMnemonic(String entropyMnemonic) {
  //   return bip39.entropyToMnemonic(entropyMnemonic);
  // }
}
