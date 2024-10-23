import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/util/logger.dart';

mixin class CreateEvent {
  // Check Image 눌렀을때,
  onPressedCheckImage(String text, ValueNotifier<String> imageUrl) {
    imageUrl.value = text;
  }

  onPressedCreateNFT(
    WidgetRef ref,
    BuildContext context, {
    required String imageUrl,
  }) async {
    final result = await mintNftUseCase.call(imageUrl);
    CLogger.i(result);
  }
}