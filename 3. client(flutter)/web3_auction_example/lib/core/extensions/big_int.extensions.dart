import 'package:web3dart/web3dart.dart';

extension BigintExtensions on BigInt {
  // BigInt를 DateTime으로 변환
  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(toInt() * 1000);
  }

  String get toStringInEther {
    return EtherAmount.fromBigInt(EtherUnit.wei, this)
        .getValueInUnit(EtherUnit.ether)
        .toString();
  }

  String get toStringInGas {
    return EtherAmount.fromBigInt(EtherUnit.gwei, this)
        .getValueInUnit(EtherUnit.ether)
        .toString();
  }
}
