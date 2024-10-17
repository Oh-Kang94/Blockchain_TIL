import 'package:freezed_annotation/freezed_annotation.dart';

part 'signin.dto.freezed.dart';

@freezed
class SignInDto with _$SignInDto {
  factory SignInDto({
    required String privateKey,
    String? name,
  }) = _SignInDto;
}