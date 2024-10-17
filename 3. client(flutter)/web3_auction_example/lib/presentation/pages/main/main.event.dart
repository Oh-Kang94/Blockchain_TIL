import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/presentation/providers/main_bottom_navigation.provider.dart';

mixin class MainEvent {
  // Tap
  void onTapBottomNavigationItem(
    WidgetRef ref, {
    required int index,
  }) {
    ref.read(mainBottomNavigationProvider.notifier).tab =
        MainNavigationTab.values[index];
  }
}
