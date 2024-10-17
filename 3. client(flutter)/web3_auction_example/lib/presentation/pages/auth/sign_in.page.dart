import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/presentation/pages/auth/sign_in.event.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';

class SignInPage extends BasePage with AuthEvent {
  const SignInPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text("Auth"),
        ],
      ),
    );
  }
}
