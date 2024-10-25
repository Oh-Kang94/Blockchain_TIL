import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/extensions/string.extensions.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/presentation/pages/mypage/my_page.event.dart';
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

  final double height = 155;

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
                _NameText(name: name),
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

class _NameText extends HookConsumerWidget with MyPageEvent {
  const _NameText({
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: name);
    final isEditing = useState<bool>(false);
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
              "Name : $name",
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

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("data"),
    );
  }
}
