import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/features/wallet/repository/model/signin.dto.dart';
import 'package:web3_auction_example/presentation/pages/auth/sign_in.event.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_button.dart';
import 'package:web3_auction_example/presentation/widgets/common/custom_textfield.dart';
import 'package:web3_auction_example/presentation/widgets/common/space.dart';

class SignInPage extends BasePage with AuthEvent {
  const SignInPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final privateKeyController = useTextEditingController();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "NFT Example App",
              style: AppTextStyle.headline1.copyWith(
                color: AppColor.of.primary,
              ),
            ),
            const Space(
              properties: SpaceProperties.column,
              80,
            ),
            HookBuilder(
              builder: (context) {
                return CustomTextfield(
                  controller: privateKeyController,
                  focusNode: FocusNode(),
                  label: 'PrivateKey',
                  hintText: 'PrivateKey',
                  enabled: true,
                  isObscure: true,
                  onClear: () => privateKeyController.clear(),
                );
              },
            ),
            Space.defaultColumn(),
            CustomButton(
              content: 'Sign In',
              onPressed: () async => onTapSignin(
                ref,
                signIn: SignInDto(privateKey: privateKeyController.text),
              ),
              buttonSize: ButtonSize.medium,
              buttonHierarchy: ButtonHierarchy.primary,
              // canSelect: false,
            ),
            Space.defaultColumn(),
            CustomButton(
              content: 'Sign Out',
              onPressed: () {},
              buttonSize: ButtonSize.medium,
              buttonHierarchy: ButtonHierarchy.secondary,
              // canSelect: false,
            ),
          ],
        ),
      ),
    );
  }
}


// ^(0x)?[a-fA-F0-9]{64}$ PrivateKey Regex
