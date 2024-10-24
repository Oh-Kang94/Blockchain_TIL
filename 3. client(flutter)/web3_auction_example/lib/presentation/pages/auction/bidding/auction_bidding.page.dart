import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/core/extensions/big_int.extensions.dart';
import 'package:web3_auction_example/core/util/app_size.dart';
import 'package:web3_auction_example/presentation/pages/auction/bidding/auction_bidding.event.dart';
import 'package:web3_auction_example/presentation/pages/auction/bidding/auction_bidding.state.dart';
import 'package:web3_auction_example/presentation/pages/auction/bidding/components/bidding_card.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_button.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_textfield.dart';
import 'package:web3_auction_example/presentation/widgets/common/default_app_bar.dart';
import 'package:web3_auction_example/presentation/widgets/common/space.dart';
import 'package:web3dart/web3dart.dart';

class AuctionBiddingPage extends BasePage
    with AuctionBiddingEvent, AuctionBiddingState {
  const AuctionBiddingPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final priceController = useTextEditingController();
    final scrollController = useScrollController();
    return bidListActiveAsync(ref).when(
      data: (data) {
        final BigInt minPriceBigInt =
            (data[0].price * BigInt.from(11)) ~/ BigInt.from(10);
        final double minPrice =
            EtherAmount.fromBigInt(EtherUnit.wei, minPriceBigInt)
                .getValueInUnit(EtherUnit.ether);
        priceController.text = minPrice.toString();

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Image",
                style: AppTextStyle.headline1,
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Image.network(
                  imageUrlAsync(ref).value!,
                ),
              ),
              Space.defaultColumn(),
              Text(
                "Current Price : ${data[0].price.toStringInEther} eth",
                style: AppTextStyle.title1,
              ),
              Space.defaultColumn(),
              Text(
                "Logs",
                style: AppTextStyle.title1,
              ),
              Space.defaultColumn(),
              Container(
                height: AppSize.to.screenHeight * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.of.gray,
                ),
                child: Scrollbar(
                  controller: scrollController,
                  child: ListView.separated(
                    itemCount: data.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return BiddingCard.fromBidEntity(bid: data[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const Space(5, properties: SpaceProperties.column);
                    },
                  ),
                ),
              ),
              Space.defaultColumn(),
              CustomTextfield(
                controller: priceController,
                focusNode: FocusNode(),
                label: "Bidding Price",
                hintText: '',
              ),
              const Spacer(),
              CustomButton(
                content: "Bidding!",
                onPressed: () => clickBidding(
                  ref,
                  context,
                  biddingPrice: priceController.text,
                  listingId: data[0].listingId,
                ),
                buttonSize: ButtonSize.large,
                buttonHierarchy: ButtonHierarchy.primary,
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: ErrorWidget(error),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return DefaultAppBar(
      ref,
      title: 'Bidding Auction',
      hasLeading: true,
    );
  }
}
