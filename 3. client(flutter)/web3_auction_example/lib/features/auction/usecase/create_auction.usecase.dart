import 'dart:async';

import 'package:web3_auction_example/core/extensions/big_int.extensions.dart';
import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/auction/entities/auction_result.entity.dart';
import 'package:web3_auction_example/features/auction/repository/auction.repository.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction.dto.dart';
import 'package:web3dart/web3dart.dart';

class CreateAuctionUseCase
    extends BaseUseCase<AuctionDto, Result<AuctionResultEntity>> {
  final AuctionRepository _auctionRepository;

  CreateAuctionUseCase(this._auctionRepository);

  @override
  FutureOr<Result<AuctionResultEntity>> call(AuctionDto request) async {
    try {
      CLogger.i("Request From UseCase : $request");
      final result =
          await _auctionRepository.createAuction(auctionDto: request);

      final AuctionResultEntity auctionResultEntity = result.fold(
        onSuccess: (element) {
          final dto = element.$1;
          final gasFee = element.$2;

          return AuctionResultEntity(
            auctionId: dto.listingId.toDouble(),
            tokenId: dto.tokenId.toString(),
            gasFee: EtherAmount.fromBigInt(EtherUnit.wei, gasFee),
            startedAt: dto.startAt.toDateTime(),
            endedAt: dto.endAt.toDateTime(),
            price: EtherAmount.fromBigInt(EtherUnit.wei, dto.price),
          );
        },
        onFailure: (e) => throw NetworkException(e.toString()),
      );

      CLogger.i(auctionResultEntity);
      return Result.success(auctionResultEntity);
    } catch (e) {
      return Result.failure(UndefinedException(e.toString()));
    }
  }
}
