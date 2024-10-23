import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';
import 'package:web3_auction_example/presentation/pages/create/create.event.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_button.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_textfield.dart';
import 'package:web3_auction_example/presentation/widgets/common/space.dart';

class CreatePage extends BasePage with CreateEvent {
  const CreatePage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final TextEditingController imageUrlController = useTextEditingController();
    final imageUrl = useState<String>('');
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Space(
            50,
            properties: SpaceProperties.column,
          ),
          CustomTextfield(
            controller: imageUrlController,
            focusNode: FocusNode(),
            label: 'ImageUrl',
            hintText: '',
            isClear: true,
            onClear: () {
              imageUrlController.clear();
              imageUrl.value = '';
            },
          ),
          const Spacer(),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.of.gray,
              ),
            ),
            child: Image.network(
              imageUrl.value,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.image));
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child; // 이미지 로딩이 끝난 경우
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 150,
                child: CustomButton(
                  content: 'Check Image',
                  onPressed: () =>
                      onPressedCheckImage(imageUrlController.text, imageUrl),
                  buttonSize: ButtonSize.large,
                  buttonHierarchy: ButtonHierarchy.primary,
                ),
              ),
              SizedBox(
                width: 150,
                child: CustomButton(
                  content: 'Create NFT',
                  onPressed: () => onPressedCreateNFT(
                    ref,
                    context,
                    imageUrl: imageUrl.value,
                  ),
                  buttonSize: ButtonSize.large,
                  buttonHierarchy: ButtonHierarchy.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
