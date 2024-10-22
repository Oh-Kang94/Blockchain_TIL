import 'package:web3_auction_example/app/di/app_binding.dart';
import 'package:web3_auction_example/app/di/modules/feature_di_interface.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/features/auction/repository/auction.repository.dart';
import 'package:web3_auction_example/features/auction/repository/auction.repository.impl.dart';
import 'package:web3_auction_example/features/auction/usecase/create_auction.usecase.dart';

final class AuctionDI extends IFeatureDI {
  @override
  void dataSources() {}

  @override
  void repositories() {
    locator.registerLazySingleton<AuctionRepository>(
      () => AuctionRepositoryImpl(
        web3DataSource,
        walletRepository,
      ),
    );
  }

  @override
  void useCases() {
    locator.registerFactory(() => CreateAuctionUseCase(auctionRepository));
  }
}
