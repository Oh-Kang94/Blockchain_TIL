import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/util/app_size.dart';
import 'package:web3_auction_example/presentation/pages/home/home_state.dart';
import 'package:web3_auction_example/presentation/pages/home/widgets/nft_card.dart';
import 'package:web3_auction_example/presentation/providers/nft/nft_list_provider.dart';

class NftSection extends ConsumerWidget with HomeState {
  const NftSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return nftListAsync(ref).when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(
            child: Text("자료가 없습니다."),
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
