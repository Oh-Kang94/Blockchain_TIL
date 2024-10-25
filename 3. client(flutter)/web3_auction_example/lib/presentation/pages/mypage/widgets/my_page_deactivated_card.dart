import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/extensions/datetime_extensions.dart';
import 'package:web3_auction_example/core/util/snack_bar_service.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/presentation/widgets/common/placeholders.dart';

class MyPageDeactivatedCard extends StatelessWidget {
  const MyPageDeactivatedCard({
    super.key,
    required this.privateKey,
    required this.name,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.amount,
    required this.isLoaded,
  });
  final int privateKey;
  final String name;
  final String address;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String amount;
  final bool isLoaded;

  factory MyPageDeactivatedCard.fromWalletEntity({
    required WalletEntity wallet,
  }) {
    return MyPageDeactivatedCard(
      privateKey: wallet.privateKey,
      name: wallet.name ?? '별칭을 정해주세요',
      address: wallet.address,
      createdAt: wallet.createdAt,
      updatedAt: wallet.updatedAt,
      amount: wallet.amount.toString(),
      isLoaded: true,
    );
  }

  factory MyPageDeactivatedCard.createSkeleton() => MyPageDeactivatedCard(
        privateKey: 0,
        name: '',
        address: '',
        createdAt: DateTime(0),
        updatedAt: DateTime(0),
        amount: '',
        isLoaded: false,
      );

  double get height => 143;

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Container(
            key: ValueKey(privateKey),
            height: height,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.of.gray),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name : $name"),
                    const Text("Address : "),
                    GestureDetector(
                      onTap: () async {
                        SnackBarService.showSnackBar("Success to Copied");
                        await Clipboard.setData(ClipboardData(text: address));
                      },
                      child: Text(
                        address,
                        style: AppTextStyle.alert1,
                      ),
                    ),
                    Text("Amount : $amount (eth)"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Created At : ${createdAt.getDateFormat}"),
                    Text(
                      "Updated At : ${(updatedAt ?? createdAt).getDateFormat}",
                    ),
                  ],
                ),
              ],
            ),
          )
        : Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: BannerPlaceholder(
              height: height,
            ),
          );
  }
}
