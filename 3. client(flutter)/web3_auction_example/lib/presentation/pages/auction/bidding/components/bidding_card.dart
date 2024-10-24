import 'package:flutter/material.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/core/extensions/big_int.extensions.dart';
import 'package:web3_auction_example/core/extensions/datetime_extensions.dart';
import 'package:web3_auction_example/features/auction/entities/bid.entity.dart';
import 'package:web3dart/web3dart.dart';

class BiddingCard extends StatelessWidget {
  const BiddingCard({
    super.key,
    required this.seller,
    required this.tokenId,
    required this.price,
    required this.netPrice,
    required this.startAt,
    required this.endAt,
  });
  final String seller;
  final String tokenId;
  final String price;
  final String netPrice;
  final DateTime startAt;
  final DateTime endAt;

  factory BiddingCard.fromBidEntity({required BidEntity bid}) {
    return BiddingCard(
      seller: bid.seller.toString(),
      tokenId: bid.tokenId.toString(),
      price: bid.price.toStringInEther,
      netPrice: bid.netPrice.toStringInEther,
      startAt: bid.startAt,
      endAt: bid.endAt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.of.black),
        borderRadius: BorderRadius.circular(10),
        color: AppColor.of.white,
      ),
      child: Column(
        children: [
          Text("Price : $price eth"),
          Text("Net Price : $netPrice eth"),
          Text("Start At : ${startAt.getDateFormat}"),
          Text("End At : ${endAt.getDateFormat}"),
        ],
      ),
    );
  }
}
