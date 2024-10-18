import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/router/routes.dart';
import 'package:web3_auction_example/core/util/snack_bar_service.dart';
import 'package:web3_auction_example/features/wallet/repository/model/signin.dto.dart';
import 'package:web3_auction_example/presentation/providers/wallet/auth.provider.dart';

mixin class AuthEvent {
  Future<void> onTapSignin(
    WidgetRef ref, {
    required SignInDto signIn,
  }) async {
    await ref.read(authProvider.notifier).signIn(signIn);
    return ref.read(authProvider.future).then(
      (value) {
        if (value is AuthSuccess && ref.context.mounted) {
          const MainRoute().go(ref.context);
        } else {
          SnackBarService.showSnackBar("Failed to Auth");
        }
      },
    );
  }
}