import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'routes.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// RiverPod이랑 같이 initialize 하기 위해, Generate 된걸 가져온다.
@riverpod
GoRouter router(RouterRef ref) {
  // TODO : Impl for auth
  // final routerKey = GlobalKey<NavigatorState>(debugLabel: 'routerKey');
  // final isAuth = ValueNotifier<AsyncValue<bool>>(const AsyncLoading());
  // ref
  //   ..onDispose(isAuth.dispose) // don't forget to clean after yourselves (:
  //   // update the listenable, when some provider value changes
  //   // here, we are just interested in wheter the user's logged in
  //   ..listen(
  //       // authControllerProvider
  //       //     .select((value) => value.whenData((value) => value.isAuth)),
  //       // (_, next) {
  //       //   isAuth.value = next;
  //       // },
  //       // End
  //       );
  // End

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    // TODO : Impl for Auth
    // refreshListenable: isAuth,
    // End
    initialLocation: const SplashRoute().location,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    // TODO : Impl Redirect
    // redirect: (context, state) {
    //   if (isAuth.value.unwrapPrevious().hasError)
    //     return const LoginRoute().location;
    //   if (isAuth.value.isLoading || !isAuth.value.hasValue)
    //     return const SplashRoute().location;

    //   final auth = isAuth.value.requireValue;

    //   final isSplash = state.uri.path == const SplashRoute().location;
    //   if (isSplash)
    //     return auth ? const HomeRoute().location : const LoginRoute().location;

    //   final isLoggingIn = state.uri.path == const LoginRoute().location;
    //   if (isLoggingIn) return auth ? const HomeRoute().location : null;

    //   return auth ? null : const SplashRoute().location;
    // },
  );
  ref.onDispose(router.dispose); // always clean up after yourselves (:

  return router;
}
