import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/util/app_size.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';
import 'package:web3_auction_example/presentation/pages/home/home.state.dart';
import 'package:web3_auction_example/presentation/widgets/common/nft_card.widget.dart';
import 'package:web3_auction_example/presentation/providers/nft/nft_list.provider.dart';

class NftSection extends ConsumerWidget with HomeState {
  const NftSection({super.key, required this.nftList});
  final AsyncValue<List<NftEntity>> nftList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return nftList.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(
            child: Text("해당하는 NFT가 없습니다."),
          );
        }
        return SizedBox(
          height: AppSize.to.screenHeight * 0.7,
          child: RefreshIndicator(
            onRefresh: () async => await ref.refresh(nftListProvider),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return NftCard.fromNftEntity(
                  entity: data[index],
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
              onPressed: () async => await ref.refresh(nftListProvider),
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
    );
  }
}
