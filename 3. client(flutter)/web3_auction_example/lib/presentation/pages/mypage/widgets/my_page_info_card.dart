import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/extensions/string_extensions.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/presentation/widgets/common/placeholders.dart';

class MyPageInfoCard extends StatelessWidget {
  const MyPageInfoCard({
    super.key,
    required this.name,
    required this.address,
    required this.isLoaded,
    required this.amount,
  });
  final String name;
  final String address;
  final bool isLoaded;
  final double amount;

  factory MyPageInfoCard.fromWalletEntity(WalletEntity wallet) {
    return MyPageInfoCard(
      name: wallet.name ?? '별칭을 정해주세요',
      address: wallet.address,
      isLoaded: true,
      amount: wallet.amount,
    );
  }

  factory MyPageInfoCard.createSkeleton() {
    return const MyPageInfoCard(
      name: '',
      address: '',
      isLoaded: false,
      amount: 0,
    );
  }

  final double height = 130;

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return Container(
        height: height,
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.of.gray),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Wallet",
              style: AppTextStyle.headline1.copyWith(
                color: AppColor.of.primary,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name : $name",
                ),
                _AddressText(address),
                Text(
                  "Balance : $amount (ETH)",
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: BannerPlaceholder(
        height: height,
      ),
    );
  }
}

class _AddressText extends StatefulWidget {
  const _AddressText(this.address);
  final String address;

  @override
  State<_AddressText> createState() => _AddressTextState();
}

class _AddressTextState extends State<_AddressText> {
  bool isShowAll = false;
  late String addressD;
  @override
  void initState() {
    addressD = widget.address.mask;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isShowAll = !isShowAll;
        if (isShowAll) {
          addressD = widget.address;
        } else {
          addressD = widget.address.mask;
        }
        setState(() {});
      },
      child: Text(
        "Address: $addressD",
      ),
    );
  }
}
