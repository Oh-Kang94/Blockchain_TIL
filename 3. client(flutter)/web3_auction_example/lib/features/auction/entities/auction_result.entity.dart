import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'auction_result.entity.freezed.dart';

@freezed
class AuctionResultEntity with _$AuctionResultEntity {
  factory AuctionResultEntity({
    required double auctionId,
    required String tokenId,
    required EtherAmount gasFee,
    required DateTime startedAt,
    required DateTime endedAt,
    required EtherAmount price,
  }) = _AuctionResultEntity;
}
