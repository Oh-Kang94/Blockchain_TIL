import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/presentation/providers/wallet/wallet_list.provider.dart';

mixin class MyPageEvent {
  selectWalletForActivate(
    WidgetRef ref, {
    required WalletEntity walletEntity,
  }) async {
    unawaited(HapticFeedback.vibrate());
    final newWallet = walletEntity.copyWith(isActivate: true);
    await ref.read(walletListProvider.notifier).selectForActivate(newWallet);
  }
}
