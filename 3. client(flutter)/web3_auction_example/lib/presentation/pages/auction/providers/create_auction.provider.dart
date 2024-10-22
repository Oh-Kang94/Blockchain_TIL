import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/features/auction/entities/auction_result.entity.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction.dto.dart';

part 'create_auction.provider.g.dart';

@riverpod
class CreateAuction extends _$CreateAuction {
  @override
  AsyncValue<AuctionResultEntity?> build() {
    return const AsyncValue.loading();
  }

  Future<void> createAuction(AuctionDto auctionDto) async {
    state = const AsyncValue.loading();

    final Result<AuctionResultEntity> result =
        await createAuctionUseCase.call(auctionDto);

    state = result.fold(
      onSuccess: (auctionResult) => AsyncValue.data(auctionResult),
      onFailure: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
