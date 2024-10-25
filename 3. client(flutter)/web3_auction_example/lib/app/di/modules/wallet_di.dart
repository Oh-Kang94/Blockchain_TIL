import 'package:web3_auction_example/app/di/app_binding.dart';
import 'package:web3_auction_example/app/di/modules/feature_di_interface.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/datasource/local/isar.datasource.dart';
import 'package:web3_auction_example/core/datasource/local/secure_storage.datasource.dart';
import 'package:web3_auction_example/core/datasource/local/secure_storage.datasource.impl.dart';
import 'package:web3_auction_example/core/service/address.service.dart';
import 'package:web3_auction_example/core/service/address.service.impl.dart';
import 'package:web3_auction_example/features/wallet/usecases/activate_wallet.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/auth.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/get_wallet_list.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/logout.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/signin.usecase.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.impl.dart';
import 'package:web3_auction_example/features/wallet/usecases/update_wallet.usecase.dart';

final class WalletDI extends IFeatureDI {
  @override
  void dataSources() {
    locator
      ..registerLazySingleton<IsarDataSource>(
        () => IsarDataSource(),
      )
      ..registerLazySingleton<SecureStorageDatasource>(
        () => SecureStorageDatasourceImpl(),
      )
      ..registerLazySingleton<AddressService>(
        () => AddressServiceImpl(),
      );
  }

  @override
  void repositories() {
    locator.registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(
        isarDatasource,
        secureStorageDatasource,
        addressService,
        web3DataSource,
      ),
    );
  }

  @override
  void useCases() {
    // ignore: avoid_single_cascade_in_expression_statements
    locator
      ..registerFactory<SignInUseCase>(() => SignInUseCase(walletRepository))
      ..registerFactory<AuthUsecase>(() => AuthUsecase(walletRepository))
      ..registerFactory<ActivateWalletUseCase>(
        () => ActivateWalletUseCase(walletRepository),
      )
      ..registerFactory<LogoutUsecase>(() => LogoutUsecase(walletRepository))
      ..registerFactory<UpdateWalletUsecase>(
        () => UpdateWalletUsecase(walletRepository),
      )
      ..registerFactory<GetWalletListUseCase>(
        () => GetWalletListUseCase(walletRepository),
      );
  }
}
