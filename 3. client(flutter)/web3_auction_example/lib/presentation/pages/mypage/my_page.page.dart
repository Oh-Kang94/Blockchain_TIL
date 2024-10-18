import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';
import 'package:web3_auction_example/presentation/pages/mypage/my_page.event.dart';
import 'package:web3_auction_example/presentation/pages/mypage/my_page.state.dart';
import 'package:web3_auction_example/presentation/pages/mypage/widgets/my_page_info_card.dart';

class MyPage extends BasePage with MyPageEvent, MyPageState {
  const MyPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _walletCard(ref),
        ],
      ),
    );
  }

  Widget _walletCard(ref) {
    return activatedWalletAsync(ref).when(
      data: (data) {
        return MyPageInfoCard.fromWalletEntity(data);
      },
      error: (error, stackTrace) {
        return ErrorWidget(error);
      },
      loading: () {
        return MyPageInfoCard.createSkeleton();
      },
    );
  }
}
