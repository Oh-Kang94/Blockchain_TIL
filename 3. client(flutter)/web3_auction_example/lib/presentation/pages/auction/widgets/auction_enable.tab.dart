import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/router/routes.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/util/app_size.dart';
import 'package:web3_auction_example/presentation/pages/auction/auction.state.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/nft_list_own.provider.dart';
import 'package:web3_auction_example/presentation/widgets/common/nft_card.widget.dart';
import 'package:web3_auction_example/presentation/widgets/common/space.dart';

class AuctionEnableTabView extends HookConsumerWidget with AuctionState {
  const AuctionEnableTabView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Own NFT : ${(nftOwnListAsync(ref).value ?? []).length} (EA)",
              style: AppTextStyle.title1,
            ),
          ),
          Space.defaultColumn(),
          nftOwnListAsync(ref).when(
            data: (data) {
              if (data.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("해당하는 NFT가 없습니다."),
                        Space.defaultColumn(),
                        CupertinoButton(
                          onPressed: () async =>
                              await ref.refresh(nftListOwnProvider),
                          child: Text(
                            "Refresh",
                            style: AppTextStyle.headline1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox(
                height: AppSize.to.screenHeight * 0.6,
                child: RefreshIndicator(
                  onRefresh: () async => await ref.refresh(nftListOwnProvider),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => AuctionCreateRoute(data[index].tokenId)
                            .push(context),
                        child: NftCard.fromNftEntity(
                          entity: data[index],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            error: (error, stackTrace) => Center(
              child: Column(
                children: [
                  Text(
                    error.toString(),
                  ),
                  CupertinoButton(
                    onPressed: () async =>
                        await ref.refresh(nftListOwnProvider),
                    child: Text(
                      "Refresh",
                      style: AppTextStyle.headline1,
                    ),
                  ),
                ],
              ),
            ),
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
