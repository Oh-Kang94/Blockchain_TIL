import 'package:flutter/material.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';

class AuctionCard extends StatelessWidget {
  final String name;
  final String tokenId;
  final String price;
  final String imgUrl;
  final bool isAuction;
  const AuctionCard({
    super.key,
    required this.name,
    required this.tokenId,
    required this.price,
    required this.imgUrl,
    required this.isAuction,
  });

  factory AuctionCard.fromNftEntity({required NftEntity entity}) {
    return AuctionCard(
      name: entity.name,
      tokenId: entity.tokenId.toString(),
      price: entity.price,
      imgUrl: entity.imageUrl,
      isAuction: entity.isAuction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.of.gray,
        border: Border.all(color: AppColor.of.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 110,
            child: Image.network(
              imgUrl,
              errorBuilder: (_, __, ___) => const Icon(Icons.image),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "NFT name :",
                style: AppTextStyle.title2,
              ),
              Text(name),
            ],
          ),
          if (isAuction)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Price :",
                  style: AppTextStyle.title2,
                ),
                Text("$price Eth"),
              ],
            ),
        ],
      ),
    );
  }
}
