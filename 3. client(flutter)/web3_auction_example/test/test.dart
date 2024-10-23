import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_auction_example/app/di/app_binding.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/app/env/env.enum.dart';
import 'package:web3_auction_example/app/env/flavor.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load();
  setUp(() async {
    await dotenv.load();
    HttpOverrides.global = MyHttpOverrides();
    Flavor.initialize(Env.localhost);
    // 실제 API와 통신하는 repository를 사용
    await AppBinding.init();
  });

  test('MintNftUsecase 실제 통신 테스트', () async {
    // Given: 실제로 존재하는 NFT tokenUri를 준비
    const tokenUri = 'https://picsum.photos/id/100/200/300';

    // When: MintNftUsecase가 호출되었을 때
    final result = await mintNftUseCase.call(tokenUri);

    // Then: 결과가 성공적으로 반환되는지 확인
    if (result is Success) {
      final mintedEvent = result.getOrThrow().$1;
      final gasCost = result.getOrThrow().$2;

      print('Minter: ${mintedEvent.minterAddress}');
      print('TokenId: ${mintedEvent.tokenId}');
      print('Gas Cost: $gasCost');

      // 추가로 응답 데이터가 올바른지 검증할 수 있음
      expect(mintedEvent.minterAddress, isNotNull);
      expect(mintedEvent.tokenId, isNotNull);
      expect(gasCost, isNotNull);
    } else {
      print('Error: $result');
      fail('MintNftUsecase failed with exception: ${result}');
    }
  });
}
