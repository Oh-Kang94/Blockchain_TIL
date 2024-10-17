import 'package:web3_auction_example/app/di/app_binding.dart';
import 'package:web3_auction_example/core/datasource/local/isar.datasource.dart';
import 'package:web3_auction_example/core/datasource/local/secure_storage.datasource.dart';
import 'package:web3_auction_example/core/datasource/remote/web3.datasource.dart';
import 'package:web3_auction_example/core/service/address.service.dart';
import 'package:web3_auction_example/features/wallet/usecases/signin.usecase.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';
import 'package:web3_auction_example/features/nft/repository/nft.repository.dart';
import 'package:web3_auction_example/features/nft/usecases/get_nft_image.usecase.dart';

final web3DataSource = locator<Web3Datasource>();
final nftRepository = locator<NftRepository>();
final getNftImage = locator<GetNftImageUseCase>();
final isarDatasource = locator<IsarDataSource>();
final secureStorageDatasource = locator<SecureStorageDatasource>();
final addressService = locator<AddressService>();
final signInUseCase = locator<SignInUseCase>();
final authRepository = locator<WalletRepository>();
