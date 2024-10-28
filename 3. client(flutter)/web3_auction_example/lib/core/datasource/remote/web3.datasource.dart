import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3_auction_example/app/env/flavor.dart';
import 'package:web3dart/web3dart.dart';

class Web3Datasource {
  late Web3Client _client;
  // Localhost : RpcUrl from hardhat.config.js
  final String _rpcUrl = Flavor.env.rpcUrl;
  final int _chainId = Flavor.env.chainId;
  // late final DeployedContract _contract;

  // 배포된 계약의 주소를 설정
  final EthereumAddress _contractAddress = EthereumAddress.fromHex(
    Flavor.env.contract,
  );

  EthPrivateKey privateKey = EthPrivateKey.createRandom(Random.secure());

  Web3Client get client => _client;
  // DeployedContract get contract => _contract;
  int get chainId => _chainId;

  Web3Datasource() {
    _client = Web3Client(_rpcUrl, Client());
  }

  Future<DeployedContract> getContract() async {
    String abi = await _loadAbi();
    return DeployedContract(
      ContractAbi.fromJson(abi, "NftSaleable"),
      _contractAddress,
    );
  }

  Future<String> _loadAbi() async {
    // JSON 파일 읽기
    String jsonString =
        await rootBundle.loadString("assets/abi/NftSaleable.json");

    // JSON 파싱
    final jsonMap = jsonDecode(jsonString);

    // 'abi' 필드 추출
    final abi = jsonMap['abi'];

    // 'abi'를 String으로 변환하여 반환
    return jsonEncode(abi); // JSON String으로 변환
  }
}
