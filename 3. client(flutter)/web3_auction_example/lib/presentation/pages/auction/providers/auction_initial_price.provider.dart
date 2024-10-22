import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auction_initial_price.provider.g.dart';

@riverpod
class AuctionInitialPrice extends _$AuctionInitialPrice {
  @override
  Raw<TextEditingController> build() {
    return TextEditingController();
  }

  String? checkIsDouble(String? input) {
    if (input == null) {
      return '경매 최소 금액을 입력해주세요.';
    }
    if (double.tryParse(input) == null) {
      return '숫자를 입력해주세요.';
    }
    return null;
  }
}
