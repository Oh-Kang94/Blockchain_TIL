import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';
part 'auth_provider.freezed.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  FutureOr<AuthState> build() async {
    late AuthState state;
    await Future.delayed(
      const Duration(seconds: 1),
    );
    state = AuthState.success();
    return state;
  }
}

@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();
  factory AuthState.success() = AuthSuccess;
  factory AuthState.fail() = AuthFailed;
  bool get isAuth => switch (this) {
        AuthSuccess() => true,
        AuthFailed() => false,
      };
}

// Reference : https://github.dev/lucavenir/go_router_riverpod/blob/master/example/lib/router/router.dart