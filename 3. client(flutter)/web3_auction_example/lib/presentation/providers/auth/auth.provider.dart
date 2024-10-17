import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/model/signin.dto.dart';

part 'auth.provider.g.dart';
part 'auth.provider.freezed.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  FutureOr<AuthState> build() async {
    return AuthState.fail();
  }

  Future<void> signIn(SignInDto signIn) async {
    final result = await signInUseCase.call(signIn);
    result.fold(
      onSuccess: (value) {
        state = AsyncData(
          AuthState.success(wallet: value),
        );
      },
      onFailure: (e) {
        CLogger.e('Error $e');
        state = AsyncData(
          AuthState.fail(),
        );
      },
    );
  }
}

@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();
  factory AuthState.success({
    required WalletEntity wallet,
  }) = AuthSuccess;
  factory AuthState.fail() = AuthFailed;
  bool get isAuth => switch (this) {
        AuthSuccess() => true,
        AuthFailed() => false,
      };
}

// Reference : https://github.dev/lucavenir/go_router_riverpod/blob/master/example/lib/router/router.dart