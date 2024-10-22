import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/router/routes.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/util/app_size.dart';
import 'package:web3_auction_example/presentation/pages/auction/auction.state.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/nft_list_own.provider.dart';
import 'package:web3_auction_example/presentation/widgets/common/nft_card.widget.dart';
import 'package:web3_auction_example/presentation/widgets/common/space.dart';

class AuctionListingTabView extends HookConsumerWidget with AuctionState {
  const AuctionListingTabView({super.key});
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
              "Own NFT : ${(nftListAsync(ref).value ?? []).length} (EA)",
              style: AppTextStyle.title1,
            ),
          ),
          const Space(
            properties: SpaceProperties.column,
          ),
          nftListAsync(ref).when(
            data: (data) {
              if (data.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const Text("해당하는 NFT가 없습니다."),
                      ElevatedButton(
                        onPressed: () async =>
                            await ref.refresh(nftListOwnProvider),
                        child: Text(
                          "Refresh",
                          style: AppTextStyle.alert1,
                        ),
                      ),
                    ],
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
                  ElevatedButton(
                    onPressed: () async =>
                        await ref.refresh(nftListOwnProvider),
                    child: Text(
                      "Refresh",
                      style: AppTextStyle.alert1,
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
