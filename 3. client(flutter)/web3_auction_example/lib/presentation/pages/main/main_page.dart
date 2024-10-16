import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/presentation/pages/auction/auction_page.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';
import 'package:web3_auction_example/presentation/pages/create/create_page.dart';
import 'package:web3_auction_example/presentation/pages/home/home_page.dart';
import 'package:web3_auction_example/presentation/pages/main/widgets/bottom_navigation_bar.dart';
import 'package:web3_auction_example/presentation/pages/mypage/my_page.dart';
import 'package:web3_auction_example/presentation/providers/main_bottom_navigation_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class MainPage extends BasePage {
  const MainPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    const pages = [
      AuctionPage(
        key: ValueKey(MainNavigationTab.auction),
      ),
      HomePage(
        key: ValueKey(MainNavigationTab.home),
      ),
      CreatePage(
        key: ValueKey(MainNavigationTab.create),
      ),
      MyPage(
        key: ValueKey(MainNavigationTab.mypage),
      ),
    ];
    // usePageController는 Flutter Hooks 기능

    final mainTabController = usePageController(initialPage: 1);

    ref.listen(mainBottomNavigationProvider, (_, next) {
      HapticFeedback.lightImpact(); // Flutter 자체 Haptic 기능
      mainTabController.jumpToPage(next.index);
    });

    // final currentTab = ref.watch(mainBottomNavigationProvider).index;

    return PageView(
      controller: mainTabController,
      children: pages.mapIndexed((index, e) => e).toList(),
    );
  }

  @override
  Color? get unSafeAreaColor => AppColor.of.gray;

  @override
  bool get setTopSafeArea => false;

  @override
  bool get setBottomSafeArea => false;

  @override
  bool get canPop => false;

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    return const AppBottomNavigationBar();
  }
}
