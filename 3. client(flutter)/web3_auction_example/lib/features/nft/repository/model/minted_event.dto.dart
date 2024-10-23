import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'minted_event.dto.freezed.dart';

@freezed
class MintedEvent with _$MintedEvent {
  factory MintedEvent({
    required EthereumAddress minterAddress,
    required BigInt tokenId,
    required String tokenURI,
  }) = _MintedEvent;
}
