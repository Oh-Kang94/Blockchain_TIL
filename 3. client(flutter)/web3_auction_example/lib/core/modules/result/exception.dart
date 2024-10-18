import 'package:freezed_annotation/freezed_annotation.dart';

part 'exception.freezed.dart';

@freezed
sealed class CustomException with _$CustomException implements Exception {
  const factory CustomException.database() = DatabaseException;
  const factory CustomException.network(String message) = NetworkException;
  const factory CustomException.unauthorized() = UnauthorizedException;
  const factory CustomException.undefined(String message) = UndefinedException;

  // 모든 예외에 공통된 속성 정의
  const CustomException._(); // private 생성자

  String get code => when(
        database: () => 'DB001',
        network: (_) => 'NET001',
        unauthorized: () => 'AUTH001',
        undefined: (_) => '000',
      );

  String get message => when(
        database: () => '데이터베이스 오류',
        network: (msg) => msg,
        unauthorized: () => '유저 인증 정보를 불러올 수 없습니다.',
        undefined: (msg) => msg,
      );

  @override
  String toString() {
    return '$code : $message';
  }
}
