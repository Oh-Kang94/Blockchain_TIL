part of '../auction.page.dart';

class _Scaffold extends StatelessWidget {
  const _Scaffold({
    required this.tabController,
    required this.auctionCurrentTab,
    required this.auctionEnableTab,
  });
  final TabController tabController;
  final Widget auctionCurrentTab;
  final Widget auctionEnableTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TabBar(tabController),
        Expanded(
          child: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              auctionCurrentTab,
              auctionEnableTab,
            ],
          ),
        ),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar(this.tabController);
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: const [
        Tab(
          child: Center(
            child: Text("경매 리스트"),
          ),
        ),
        Tab(
          child: Center(
            child: Text("경매 하기"),
          ),
        ),
      ],
      splashFactory: NoSplash.splashFactory, // Inkwell 효과 제거,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.zero,
      dividerColor: Colors.white,
    );
  }
}
