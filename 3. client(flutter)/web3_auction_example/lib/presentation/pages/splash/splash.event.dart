import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/router/routes.dart';

mixin class SplashEvent {
  /// initialize Flag
  static bool isInitializing = false;

  Future<void> routeByUserAuth(WidgetRef ref) async {
    // auth
    await Future.delayed(const Duration(seconds: 1), () {});
    if (ref.context.mounted) {
      const MainRoute().go(ref.context);
    }
  }
}
