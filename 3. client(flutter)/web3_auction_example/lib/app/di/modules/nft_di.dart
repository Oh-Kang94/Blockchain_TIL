import 'package:web3_auction_example/app/di/app_binding.dart';
import 'package:web3_auction_example/core/datasource/remote/web3_datasource.dart';
import 'package:web3_auction_example/app/di/modules/feature_di_interface.dart';
import 'package:web3_auction_example/features/nft/repository/nft_repository.dart';
import 'package:web3_auction_example/features/nft/repository/nft_repository_impl.dart';
import 'package:web3_auction_example/features/nft/usecases/get_nft_image_use_case.dart';

final web3DataSource = locator<Web3Datasource>();
final nftRepository = locator<NftRepository>();
final getNftImage = locator<GetNftImageUseCase>();

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
    locator.registerFactory<GetNftImageUseCase>(
      () => GetNftImageUseCase(nftRepository),
    );
  }
}
