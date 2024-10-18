import 'package:flutter/material.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    this.title,
    this.actions,
  });

  final String? title;
  final List<Widget>? actions;

  static const double appbarHeight = 56;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: AppColor.of.white,
      centerTitle: false,
      automaticallyImplyLeading: false,
      leadingWidth: 56,
      actions: actions,
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          title ?? '',
          style: AppTextStyle.headline2,
        ),
      ),
      toolbarHeight: appbarHeight,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
