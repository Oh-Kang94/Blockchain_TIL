import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/util/logger.dart';

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
    wroteImageUrl.value = true;
    final result = await mintNftUseCase.call(imageUrl);
    CLogger.i(result);
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
