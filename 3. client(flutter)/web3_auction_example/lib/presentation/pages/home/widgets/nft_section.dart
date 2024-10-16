import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/presentation/pages/home/home_state.dart';
import 'package:web3_auction_example/presentation/pages/home/widgets/nft_card.dart';

class NftSection extends ConsumerWidget with HomeState{
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
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return NftCard.fromNftEntity(
              entity: data[index],
            );
          },
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(
          error.toString(),
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
