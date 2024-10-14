import 'dart:async';
import 'dart:developer';

import 'package:web3_example/controller/web3.dart';
import 'package:web3dart/web3dart.dart';

class Fundraising {
  late DeployedContract _contract;
  late ContractFunction _balanceOf;
  late ContractFunction _withdrawDonations;
  late ContractFunction _refund;
  late Web3Datasource _web3;
  late Web3Client _client;

  final EthereumAddress _contractAddress = EthereumAddress.fromHex(
      "0x5FbDB2315678afecb367f032d93F642f64180aa3"); // 배포된 계약의 주소를 설정

  Fundraising() {
    _web3 = Web3Datasource();
    _client = _web3.client;
    _initialize();
  }

  Future<void> _initialize() async {
    await _setupContract();
  }

  EthereumAddress get contractAddress => _contractAddress;

  // 스마트 컨트랙트 설정
  Future<void> _setupContract() async {
    String abi = await _web3.loadAbi("assets/abi/FundRaising.json");

    _contract = DeployedContract(
      ContractAbi.fromJson(abi, "FundRaising"),
      _contractAddress,
    );

    _balanceOf = _contract.function("balanceOf");
    _withdrawDonations = _contract.function("withdrawDonations");
    _refund = _contract.function("refund");
  }

  // 기부 함수
  FutureOr<(bool, BigInt?)> donateEth({double amountInEther = 1}) async {
    final Credentials contributor = _web3.contributor;

    // 이더를 Wei로 변환
    final amountInWei =
        EtherAmount.fromBigInt(EtherUnit.ether, BigInt.from(amountInEther));

    try {
      final String txHash = await _client.sendTransaction(
        contributor,
        Transaction(
          to: _contractAddress,
          value: amountInWei,
        ),
        chainId: 31337, // Hardhat 로컬 네트워크
      );

      final receipt = await _client.getTransactionReceipt(txHash);

      if (receipt != null) {
        final BigInt? gasUsed = receipt.gasUsed; // 사용된 가스량
        final BigInt effectiveGasPrice = receipt.effectiveGasPrice!
            .getValueInUnitBI(EtherUnit.gwei); // 가스 가격 (wei 단위)
        log('//// Start calculate Gas Fee');
        log('Gas Used: $gasUsed');
        log('Effective Gas Price: $effectiveGasPrice wei');

        // 가스비 계산
        final BigInt gasCost = gasUsed! * effectiveGasPrice; // 가스비 (wei 단위)

        log('Total Gas Cost: $gasCost wei');
        log('Total Gas Cost: ${EtherAmount.fromBigInt(EtherUnit.gwei, gasCost).getValueInUnit(EtherUnit.ether)} eth');
        log('//// End calculate Gas Fee');

        return (true, gasCost);
      }
    } catch (error) {
      log('Transaction failed: $error');
      return (false, null);
    }
    return (false, null);
  }

  /// Contract 모금액 확인
  Future<String> getBalance() async {
    final List result = await _client.call(
      contract: _contract,
      function: _balanceOf,
      params: [_web3.contributor.address],
    );
    EtherAmount etherAmount =
        EtherAmount.fromBigInt(EtherUnit.wei, result.first);

    return etherAmount.getValueInUnit(EtherUnit.ether).toString();
  }

  // CheckBalance For Contributor
  Future<EtherAmount?> checkBalance(EthereumAddress address) async {
    try {
      return await _client.getBalance(address);
    } catch (error) {
      log('Failed to fetch balance: $error');
    }
    return null;
  }

  // WithdrawDonations
  Future<(bool, String?)> withdrawDonations({Credentials? sender}) async {
    try {
      final result = await _client.sendTransaction(
        sender ?? _web3.owner,
        Transaction.callContract(
          contract: _contract,
          function: _withdrawDonations,
          parameters: [],
        ),
        chainId: 31337, // 로컬 네트워크에 맞는 체인 ID 설정
      );
      log(result);
      return (true, null);
    } catch (e) {
      if (e.toString().contains('The campaign is not over yet')) {
        return (false, 'The campaign is not over yet');
      }
      if (e.toString().contains('Funds will only be released to the owner')) {
        log(e.toString());
        return (false, 'Funds will only be released to the owner');
      }
      if (e.toString().contains('The project did not reach the goal')) {
        log(e.toString());
        return (false, 'The project did not reach the goal');
      }
      log(e.toString());
      return (false, 'Transaction failed');
    }
  }

  // Refund
  Future<(bool, String?)> refund({Credentials? sender}) async {
    try {
      await _client.sendTransaction(
        sender ?? _web3.contributor,
        Transaction.callContract(
          contract: _contract,
          function: _refund,
          parameters: [],
        ),
        chainId: 31337, // 로컬 네트워크에 맞는 체인 ID 설정
      );
      return (true, null);
    } catch (e) {
      if (e.toString().contains('The campaign is not over yet')) {
        return (false, 'The campaign is not over yet');
      }
      if (e.toString().contains('The campaign reached the goal')) {
        return (false, 'The campaign reached the goal');
      }
      if (e.toString().contains('you did not donate to this campaign')) {
        return (false, 'you did not donate to this campaign');
      }
      log(e.toString());
      return (false, 'Transaction failed');
    }
  }
}
