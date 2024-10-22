import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auction_ended_at.provider.g.dart';

@riverpod
class AuctionEndedAt extends _$AuctionEndedAt {
  @override
  DateTime? build() => null;

  void changeDate(DateTime date) {
    state = date;
  }
}