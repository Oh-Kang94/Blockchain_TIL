import 'package:flutter/material.dart';
import 'package:web3_auction_example/presentation/pages/auction/auction.page.dart';
import 'package:web3_auction_example/presentation/pages/create/create.page.dart';
import 'package:web3_auction_example/presentation/pages/home/home.page.dart';
import 'package:web3_auction_example/presentation/pages/main/main.page.dart';
import 'package:go_router/go_router.dart';
import 'package:web3_auction_example/presentation/pages/mypage/my_page.page.dart';
import 'package:web3_auction_example/presentation/pages/splash/splash.page.dart';

part 'routes.g.dart';

/// SplashScreen
@TypedGoRoute<SplashRoute>(
  path: SplashRoute.path,
  name: SplashRoute.name,
)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  static const String path = '/splash';
  static const String name = 'splash';

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.0).animate(secondaryAnimation),
          child: child,
        );
      },
      child: const SplashPage(),
    );
  }
}

/// SignIn

/// Main
@TypedGoRoute<MainRoute>(
  path: MainRoute.path,
  name: MainRoute.name,
  routes: [
    TypedGoRoute<AuctionPageRoute>(
      path: AuctionPageRoute.path,
      name: AuctionPageRoute.name,
    ),
    TypedGoRoute<HomePageRoute>(
      path: HomePageRoute.path,
      name: HomePageRoute.name,
    ),
    TypedGoRoute<CreatePageRoute>(
      path: CreatePageRoute.path,
      name: CreatePageRoute.name,
    ),
    TypedGoRoute<MyPageRoute>(
      path: MyPageRoute.path,
      name: MyPageRoute.name,
    ),
  ],
)
@immutable
class MainRoute extends GoRouteData {
  const MainRoute();

  static const String path = '/';
  static const String name = 'main';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      child: const MainPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.0).animate(secondaryAnimation),
          child: child,
        );
      },
    );
  }
}

class MyPageRoute extends GoRouteData {
  const MyPageRoute();
  static const String path = 'mypage';
  static const String name = 'mypage';
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyPage();
  }
}

class HomePageRoute extends GoRouteData {
  const HomePageRoute();

  static const String path = 'home';
  static const String name = 'home';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

class CreatePageRoute extends GoRouteData {
  const CreatePageRoute();

  static const String path = 'create';
  static const String name = 'create';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CreatePage();
  }
}

class AuctionPageRoute extends GoRouteData {
  const AuctionPageRoute();

  static const String path = 'auction';
  static const String name = 'auction';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuctionPage();
  }
}