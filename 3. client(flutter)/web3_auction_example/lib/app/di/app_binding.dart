import 'package:get_it/get_it.dart';
import 'package:web3_auction_example/app/di/modules/nft_di.dart';
import 'package:web3_auction_example/core/util/logger.dart';

final locator = GetIt.I;

// 등록된 인스턴스를 해제하는 메소드
void unregister<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

// Factory SingleTon 등록하는 메소드
void registerSingleton<T extends Object>(FactoryFunc<T> factoryFunc) {
  if (!locator.isRegistered<T>()) {
    locator.registerLazySingleton<T>(factoryFunc);
  }
}

final class AppBinding {
  AppBinding._();

  static Future<void> init() async {
    // _initTopPriority();

    // 모든 Injection을 실행 시키는 Method
    for (final di in [
      NftDI(),
      // AuthDependencyInjection(),
      // UserDependencyInjection(),
      // JobDependencyInjection(),
      // ChatDependencyInject(),
      // TopicDependencyInjection(),
    ]) {
      di.init();
    }
  }
}
