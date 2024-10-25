import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/extensions/string.extensions.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/presentation/pages/mypage/my_page.event.dart';
import 'package:web3_auction_example/presentation/widgets/common/placeholders.dart';

class MyPageActivatedCard extends StatelessWidget {
  const MyPageActivatedCard({
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

  factory MyPageActivatedCard.fromWalletEntity(WalletEntity wallet) {
    return MyPageActivatedCard(
      name: wallet.name ?? '별칭을 정해주세요',
      address: wallet.address,
      isLoaded: true,
      amount: wallet.amount,
    );
  }

  factory MyPageActivatedCard.createSkeleton() {
    return const MyPageActivatedCard(
      name: '',
      address: '',
      isLoaded: false,
      amount: 0,
    );
  }

  final double height = 155;

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      CLogger.i("Build in CardWidget : $address");
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
                _NameText(name: name),
                _AddressText(address: address),
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

class _NameText extends HookConsumerWidget with MyPageEvent {
  const _NameText({
    required String name,
  }) : _name = name;

  final String _name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState<String>(_name);
    final nameController = useTextEditingController(text: _name);
    final isEditing = useState<bool>(false);

    useEffect(
      () {
        name.value = _name;
        nameController.text = _name;
        return;
      },
      [_name],
    );
    return isEditing.value
        ? Row(
            children: [
              Text(
                "Name : ",
                style: AppTextStyle.body1,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  style: AppTextStyle.body1.copyWith(color: AppColor.of.gray),
                  controller: nameController,
                  decoration: const InputDecoration.collapsed(hintText: "   "),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 100,
                height: 20,
                child: MaterialButton(
                  onPressed: () => clickDoneNameChanged(
                    ref,
                    isEditing: isEditing,
                    nameController: nameController,
                  ),
                  child: Text(
                    "Done!",
                    style: AppTextStyle.body1.copyWith(
                      color: AppColor.of.confirm,
                    ),
                  ),
                ),
              ),
            ],
          )
        : GestureDetector(
            onTap: () => isEditing.value = true,
            child: Text(
              "Name : ${name.value}",
            ),
          );
  }
}

class _AddressText extends HookConsumerWidget {
  const _AddressText({required this.address});
  final String address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowAll = useState<bool>(false);
    final addressD = useState<String>(address);

    useEffect(
      () {
        addressD.value = address.mask;
        return null;
      },
      [address],
    );

    return GestureDetector(
      onTap: () {
        isShowAll.value = !isShowAll.value;
        addressD.value = isShowAll.value ? address : address.mask;
      },
      child: Text(
        "Address: ${addressD.value}",
      ),
    );
  }
}
