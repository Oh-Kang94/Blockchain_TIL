import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';

class NftCard extends StatelessWidget {
  final String name;
  final String tokenId;
  final String price;
  final String imgUrl;
  final bool isAuction;
  const NftCard({
    super.key,
    required this.name,
    required this.tokenId,
    required this.price,
    required this.imgUrl,
    required this.isAuction,
  });

  factory NftCard.fromNftEntity({required NftEntity entity}) {
    return NftCard(
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
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Image.network(
              imgUrl,
            ),
          ),
          Text(name),
          Text(price),
          Container(
            decoration: BoxDecoration(
              color: isAuction ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}
