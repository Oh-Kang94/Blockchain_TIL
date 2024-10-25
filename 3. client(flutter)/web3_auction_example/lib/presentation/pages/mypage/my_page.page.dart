import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';
import 'package:web3_auction_example/presentation/pages/mypage/my_page.event.dart';
import 'package:web3_auction_example/presentation/pages/mypage/my_page.state.dart';
import 'package:web3_auction_example/presentation/pages/mypage/widgets/my_page_activated_card.dart';
import 'package:web3_auction_example/presentation/pages/mypage/widgets/my_page_deactivated_card.dart';
import 'package:web3_auction_example/presentation/providers/wallet/auth.provider.dart';
import 'package:web3_auction_example/presentation/providers/wallet/wallet_list.provider.dart';
import 'package:web3_auction_example/presentation/widgets/common/space.dart';

class MyPage extends BasePage with MyPageEvent, MyPageState {
  const MyPage({super.key});

  @override
  void onInit(WidgetRef ref) {
    Future.microtask(() => ref.read(authProvider.notifier).refreshWallet());
    super.onInit(ref);
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _walletCard(ref),
          Space.defaultColumn(),
          Text(
            "My Wallet List",
            style: AppTextStyle.headline1,
          ),
          Space.defaultColumn(),
          _walletList(ref),
        ],
      ),
    );
  }

  Widget _walletCard(ref) {
    return activatedWalletAsync(ref).when(
      data: (data) {
        CLogger.i("BuildWalletCard : $data");
        return MyPageActivatedCard.fromWalletEntity(data);
      },
      error: (error, stackTrace) {
        return ErrorWidget(error);
      },
      loading: () {
        return MyPageActivatedCard.createSkeleton();
      },
    );
  }

  Widget _walletList(WidgetRef ref) {
    return walletListAsync(ref).when(
      data: (List<WalletEntity> data) {
        return data.isNotEmpty
            ? Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: AppColor.of.gray,
                    ),
                  ),
                  child: ListView.separated(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(data[index]),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await ref
                                .read(walletListProvider.notifier)
                                .deleteWallet(data[index]);
                          }
                        },
                        child: GestureDetector(
                          onTap: () => clickDeactivatedCard(
                            ref,
                            privateKey: data[index].privateKey,
                          ),
                          child: MyPageDeactivatedCard.fromWalletEntity(
                            wallet: data[index],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Space(5, properties: SpaceProperties.column);
                    },
                  ),
                ),
              )
            : const Center(
                child: Text("You don't have another Wallet"),
              );
      },
      error: (error, stackTrace) {
        return ErrorWidget(error);
      },
      loading: () {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppColor.of.gray,
              ),
            ),
            child: ListView.separated(
              itemCount: 3,
              itemBuilder: (context, index) {
                return MyPageDeactivatedCard.createSkeleton();
              },
              separatorBuilder: (context, index) {
                return const Space(5, properties: SpaceProperties.column);
              },
            ),
          ),
        );
      },
    );
  }
}
