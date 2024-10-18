import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/router/routes.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/util/snack_bar_service.dart';
import 'package:web3_auction_example/presentation/providers/wallet/auth.provider.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    this.title,
    this.actions,
  });

  final String? title;
  final List<Widget>? actions;

  static const double appbarHeight = 56;

  factory DefaultAppBar.home(WidgetRef ref) {
    return DefaultAppBar(
      title: "NFT Example",
      actions: [
        IconButton(
          onPressed: () async => await _onTapLogOut(ref),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

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
          style: AppTextStyle.headline1.copyWith(color: AppColor.of.primary),
        ),
      ),
      toolbarHeight: appbarHeight,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);

  static _onTapLogOut(ref) async {
    final result = await ref.read(authProvider.notifier).logout();
    if (!result) {
      SnackBarService.showSnackBar("Failed To LogOut");
    }
  }
}
