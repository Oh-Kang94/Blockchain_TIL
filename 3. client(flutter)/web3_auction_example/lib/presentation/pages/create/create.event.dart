import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/extensions/big_int.extensions.dart';
import 'package:web3_auction_example/core/util/dialog.service.dart';
import 'package:web3_auction_example/features/nft/repository/model/minted_event.dto.dart';
import 'package:web3_auction_example/presentation/providers/main_bottom_navigation.provider.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_dialog.dart';

mixin class CreateEvent {
  // Check Image 눌렀을때,
  onPressedCheckImage(
    String text,
    ValueNotifier<String> imageUrl,
    ValueNotifier<bool> wroteImageUrl,
  ) {
    wroteImageUrl.value = true;
    imageUrl.value = text;
  }

  onPressedCreateNFT(
    WidgetRef ref,
    BuildContext context, {
    required String imageUrl,
    required ValueNotifier<bool> wroteImageUrl,
  }) async {
    if (!wroteImageUrl.value) {
      DialogService.show(
        dialog: CustomDialog.oneButton(
          title: "Failed to Create NFT",
          message: "Please, kindly check your image, first.",
          onPressed: () => Navigator.of(context).pop(),
          okMessage: "OK",
        ),
      );
      return;
    }
    (await mintNftUseCase.call(imageUrl)).when(
      success: (value) {
        final MintedEvent event = value.$1;
        final BigInt gasFee = value.$2;
        DialogService.show(
          dialog: CustomDialog.oneButton(
            title: "Success!",
            message:
                "Token Id : ${event.tokenId}\nToken URl:\n${event.tokenURI}\nGas Fee : ${gasFee.toStringInGas} (eth)",
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(mainBottomNavigationProvider.notifier).tab =
                  MainNavigationTab.values[1];
            },
            okMessage: "OK",
          ),
        );
      },
      failure: (e) {
        DialogService.show(
          dialog: CustomDialog.oneButton(
            title: "Failed",
            message:
                "Sorry to Say that please kindly check Network Connection in Your Device!",
            onPressed: () {
              Navigator.of(context).pop();
            },
            okMessage: "OK",
          ),
        );
      },
    );
  }

  clearImageUrl(
    ValueNotifier<bool> wroteImageUrl,
    TextEditingController imageUrlController,
    ValueNotifier<String?> imageUrl,
  ) {
    wroteImageUrl.value = false;
    imageUrlController.clear();
    imageUrl.value == '';
  }
}
