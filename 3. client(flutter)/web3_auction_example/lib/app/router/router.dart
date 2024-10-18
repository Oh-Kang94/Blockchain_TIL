import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/presentation/providers/wallet/auth.provider.dart';
import 'routes.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// RiverPod이랑 같이 initialize 하기 위해, Generate 된걸 가져온다.
@riverpod
GoRouter router(RouterRef ref) {
  // TODO : Impl for auth
  final isAuth = ValueNotifier<AsyncValue<bool>>(const AsyncLoading());
  ref
    ..onDispose(isAuth.dispose)
    ..listen(
      authProvider.select((value) => value.whenData((value) => value.isAuth)),
      (_, next) {
        isAuth.value = next;
      },
    );
  // End

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    refreshListenable: isAuth,
    initialLocation: const SplashRoute().location,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    redirect: (context, state) {
      if (isAuth.value.unwrapPrevious().hasError) {
        return const SignInRoute().location;
      }
      if (isAuth.value.isLoading || !isAuth.value.hasValue) {
        return const SplashRoute().location;
      }

      final auth = isAuth.value.requireValue;

      final isSplash = state.uri.path == const SplashRoute().location;
      if (isSplash) {
        return auth ? const MainRoute().location : const SignInRoute().location;
      }

      final isLoggingIn = state.uri.path == const SignInRoute().location;
      if (isLoggingIn) return auth ? const MainRoute().location : null;

      return auth ? null : const SplashRoute().location;
    },
  );
  ref.onDispose(router.dispose); // always clean up after yourselves (:

  return router;
}
