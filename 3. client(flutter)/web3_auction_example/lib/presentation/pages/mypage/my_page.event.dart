import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/core/util/snack_bar_service.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/presentation/providers/wallet/auth.provider.dart';
import 'package:web3_auction_example/presentation/providers/wallet/wallet_list.provider.dart';

mixin class MyPageEvent {
  selectWalletForActivate(
    WidgetRef ref, {
    required WalletEntity walletEntity,
  }) async {}

  clickDoneNameChanged(
    WidgetRef ref, {
    required ValueNotifier<bool> isEditing,
    required TextEditingController nameController,
  }) async {
    if (nameController.text == '') {
      SnackBarService.showFailedSnackBar(
        text: "Can't use Blank in your Address Name",
      );
      return;
    }
    WalletEntity? activateWallet = ref.read(authProvider).value!.when(
          success: (value) => value,
          logout: () => null,
          fail: () => null,
        );

    if (activateWallet == null) {
      SnackBarService.showFailedSnackBar();
      return;
    }
    WalletEntity newWallet = activateWallet.copyWith(name: nameController.text);
    final result = await ref
        .read(authProvider.notifier)
        .updateActivateWallet(newWallet: newWallet);

    if (result) {
      isEditing.value = false;
      SnackBarService.showSnackBar("Success to change Name");
    } else {
      SnackBarService.showFailedSnackBar();
    }
  }

  clickDeactivatedCard(WidgetRef ref, {required Id privateKey}) async {
    try {
      unawaited(HapticFeedback.vibrate());

      WalletEntity activateWallet = ref
          .read(walletListProvider)
          .value!
          .firstWhere((wallet) => wallet.privateKey == privateKey);

      activateWallet = activateWallet.copyWith(isActivate: true);

      await ref
          .read(walletListProvider.notifier)
          .selectForActivate(activateWallet);
      final result = await ref.read(authProvider.notifier).updateActivateWallet(
            newWallet: activateWallet.copyWith(
              isActivate: true,
            ),
          );
      if (!result) {
        SnackBarService.showFailedSnackBar();
      }
    } catch (e) {
      CLogger.e(e);
      SnackBarService.showFailedSnackBar();
    }
  }
}
