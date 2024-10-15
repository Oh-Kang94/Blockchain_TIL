import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/presentation/home.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// RiverPod이랑 같이 initialize 하기 위해, Generate 된걸 가져온다.
GoRouter appRouter(WidgetRef ref) => GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: rootNavigatorKey,
      initialLocation: HomeRoute.path,
      routes: $appRoutes,
    );

@TypedGoRoute<HomeRoute>(
  path: HomeRoute.path,
  name: HomeRoute.name,
)
@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();

  static const String path = '/home';
  static const String name = 'home';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      child: const Home(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.0).animate(secondaryAnimation),
          child: child,
        );
      },
    );
  }
}
