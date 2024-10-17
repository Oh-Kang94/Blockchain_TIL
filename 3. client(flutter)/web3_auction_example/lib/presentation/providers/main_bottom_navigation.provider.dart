import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_bottom_navigation.provider.g.dart';

enum MainNavigationTab {
  auction('경매', Icons.attach_money),
  home('홈', Icons.home),
  create('생성', Icons.create_rounded),
  mypage('내 정보', Icons.person);

  final String label;
  final IconData icon;

  const MainNavigationTab(this.label, this.icon);
}

@Riverpod(keepAlive: true)
class MainBottomNavigation extends _$MainBottomNavigation {
  @override
  MainNavigationTab build() {
    return MainNavigationTab.home;
  }

  set tab(MainNavigationTab value) => state = value;
}
