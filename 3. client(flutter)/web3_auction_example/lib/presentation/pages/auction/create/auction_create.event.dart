import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/extensions/datetime_extensions.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/util/dialog.service.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction.dto.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/auction_ended_at.provider.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/auction_initial_price.provider.dart';
import 'package:web3_auction_example/presentation/providers/auction/auction_create_arg.provider.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_dialog.dart';

mixin class AuctionCreateEvent {
  onClickCreateAuction(BuildContext context, WidgetRef ref) async {
    late AuctionDto auctionDto;
    final String initialPrice = ref.watch(auctionInitialPriceProvider).text;
    final DateTime? endedAt = ref.watch(auctionEndedAtProvider);
    final int tokenId = ref.read(auctionCreateArgProvider);
    if (initialPrice.isNotEmpty && endedAt != null) {
      auctionDto = AuctionDto(
        tokenId: BigInt.from(tokenId),
        price: BigInt.from((double.parse(initialPrice) * 1e18)),
        durationInSeconds:
            BigInt.from(endedAt.difference(DateTime.now()).inSeconds),
      );

      final Result result = await createAuctionUseCase.call(auctionDto);
      CLogger.i(result);
    } else {
      _showFailDialog(context);
      return;
    }
  }

  void _showFailDialog(context) {
    DialogService.show(
      dialog: CustomDialog.oneButton(
        title: 'Failed',
        message: 'Failed to Create',
        onPressed: () => Navigator.pop(context),
        okMessage: "OK",
      ),
    );
  }
}
