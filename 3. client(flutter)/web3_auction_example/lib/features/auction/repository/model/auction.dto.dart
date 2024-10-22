import 'package:freezed_annotation/freezed_annotation.dart';

part 'auction.dto.freezed.dart';
part 'auction.dto.g.dart';

@freezed
class AuctionDto with _$AuctionDto {
  factory AuctionDto({
    required BigInt tokenId,
    required BigInt price,
    required BigInt durationInSeconds,
  }) = _AuctionDto;

  factory AuctionDto.fromJson(Map<String, dynamic> json) =>
      _$AuctionDtoFromJson(json);
}
