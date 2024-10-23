import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/extensions/datetime_extensions.dart';
import 'package:web3_auction_example/core/util/app_size.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';
import 'package:web3_auction_example/presentation/pages/auction/create/auction_create.event.dart';
import 'package:web3_auction_example/presentation/pages/auction/create/auction_create.state.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/auction_ended_at.provider.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/auction_initial_price.provider.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_button.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_textfield.dart';
import 'package:web3_auction_example/presentation/widgets/common/default_app_bar.dart';
import 'package:web3_auction_example/presentation/widgets/common/space.dart';

class AuctionCreatePage extends BasePage
    with AuctionCreateState, AuctionCreateEvent {
  const AuctionCreatePage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return nftAsync(ref).when(
      data: (NftEntity nft) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Info",
                  style: AppTextStyle.headline1,
                ),
                Text("Name : ${nft.name}"),
                Text("SerialNumber : ${nft.tokenId}"),
                Space.defaultColumn(),
                Text(
                  "Auction State : ${nft.isAuction ? "OnGoing" : "No Auction"}",
                ),
                const Text("Image"),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor.of.primary,
                        width: 2,
                      ),
                    ),
                    child: Image.network(
                      nft.imageUrl,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                  ),
                ),
                Space.defaultColumn(),
                CustomTextfield(
                  controller: ref.read(auctionInitialPriceProvider),
                  focusNode: FocusNode(),
                  label: "Initial Price",
                  hintText: ref
                      .watch(auctionInitialPriceProvider.notifier)
                      .checkIsDouble(
                        ref.read(auctionInitialPriceProvider).text,
                      ),
                  onChanged: (value) => ref
                      .read(auctionInitialPriceProvider.notifier)
                      .checkIsDouble(value),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                Space.defaultColumn(),
                CupertinoButton(
                  onPressed: () => showCupertinoModalPopup(
                    context: ref.context,
                    builder: (context) => Container(
                      color: AppColor.of.white,
                      height: AppSize.to.screenHeight * 0.3,
                      child: CupertinoDatePicker(
                        initialDateTime:
                            ref.watch(auctionEndedAtProvider) ?? DateTime.now(),
                        minimumDate: DateTime.now().subtract(
                          const Duration(hours: 1),
                        ),
                        maximumDate:
                            DateTime.now().add(const Duration(days: 365)),
                        onDateTimeChanged: ref
                            .read(auctionEndedAtProvider.notifier)
                            .changeDate,
                        mode: CupertinoDatePickerMode.date,
                      ),
                    ),
                  ),
                  child: Text(
                    "End date : ${ref.watch(auctionEndedAtProvider).getDateFormat}",
                    style: AppTextStyle.headline1,
                  ),
                ),
                const Space(
                  properties: SpaceProperties.column,
                  50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      child: CustomButton(
                        content: "Back To List",
                        onPressed: () => Navigator.pop(context),
                        buttonSize: ButtonSize.medium,
                        buttonHierarchy: ButtonHierarchy.secondary,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: CustomButton(
                        content: "Create Auction",
                        onPressed: () => onClickCreateAuction(context, ref),
                        buttonSize: ButtonSize.medium,
                        buttonHierarchy: ButtonHierarchy.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return ErrorWidget(error);
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return DefaultAppBar(
      ref,
      title: 'Create Auction',
      hasLeading: true,
    );
  }

  @override
  bool get resizeToAvoidBottomInset => true;
}
