import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/presentation/pages/main/main.event.dart';
import 'package:web3_auction_example/presentation/providers/main_bottom_navigation.provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class AppBottomNavigationBar extends ConsumerWidget with MainEvent {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(mainBottomNavigationProvider);
    return BottomNavigationBar(
      backgroundColor: AppColor.of.white,
      currentIndex: currentTab.index,
      onTap: (value) => onTapBottomNavigationItem(
        ref,
        index: value,
      ),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      selectedItemColor: AppColor.of.black,
      unselectedItemColor: AppColor.of.gray,
      selectedLabelStyle: AppTextStyle.title1,
      unselectedLabelStyle: AppTextStyle.title1,
      items: MainNavigationTab.values
          .mapIndexed(
            (index, element) => BottomNavigationBarItem(
              label: element.label,
              icon: Icon(
                element.icon,
                color: currentTab.index == index
                    ? AppColor.of.black
                    : AppColor.of.gray,
              ),
            ),
          )
          .toList(),
    );
  }
}
