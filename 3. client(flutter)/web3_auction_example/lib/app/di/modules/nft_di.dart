import 'package:web3_auction_example/app/di/app_binding.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/datasource/remote/web3.datasource.dart';
import 'package:web3_auction_example/app/di/modules/feature_di_interface.dart';
import 'package:web3_auction_example/features/nft/repository/nft.repository.dart';
import 'package:web3_auction_example/features/nft/repository/nft.repository.impl.dart';
import 'package:web3_auction_example/features/nft/usecases/get_auction_nft_list.usecase.dart';
import 'package:web3_auction_example/features/nft/usecases/get_nft_image.usecase.dart';
import 'package:web3_auction_example/features/nft/usecases/get_own_nft_list.usecase.dart';
import 'package:web3_auction_example/features/nft/usecases/mint_nft.usecase.dart';

final class NftDI extends IFeatureDI {
  @override
  void dataSources() {
    locator.registerLazySingleton<Web3Datasource>(
      () => Web3Datasource(),
    );
  }

  @override
  void repositories() {
    locator.registerLazySingleton<NftRepository>(
      () => NftRepositoryImpl(web3DataSource),
    );
  }

  @override
  void useCases() {
    locator
      ..registerFactory<GetOwnNftListUseCase>(
        () => GetOwnNftListUseCase(nftRepository),
      )
      ..registerFactory<MintNftUsecase>(
        () => MintNftUsecase(nftRepository, walletRepository),
      )
      ..registerFactory<GetAuctionNftListUsecase>(
        () => GetAuctionNftListUsecase(nftRepository),
      )
      ..registerFactory<GetNftImageUseCase>(
        () => GetNftImageUseCase(nftRepository),
      );
  }
}
