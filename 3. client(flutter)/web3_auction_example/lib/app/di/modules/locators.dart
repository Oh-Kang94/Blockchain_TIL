import 'package:web3_auction_example/app/di/app_binding.dart';
import 'package:web3_auction_example/core/datasource/local/isar.datasource.dart';
import 'package:web3_auction_example/core/datasource/local/secure_storage.datasource.dart';
import 'package:web3_auction_example/core/datasource/remote/web3.datasource.dart';
import 'package:web3_auction_example/core/service/address.service.dart';
import 'package:web3_auction_example/features/wallet/usecases/signin.usecase.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';
import 'package:web3_auction_example/features/nft/repository/nft.repository.dart';
import 'package:web3_auction_example/features/nft/usecases/get_nft_image.usecase.dart';

// DataSource
final web3DataSource = locator<Web3Datasource>();
final isarDatasource = locator<IsarDataSource>();
final secureStorageDatasource = locator<SecureStorageDatasource>();

// Repository && Services
final nftRepository = locator<NftRepository>();
final walletRepository = locator<WalletRepository>();
final addressService = locator<AddressService>();

// Usecases
final getNftImage = locator<GetNftImageUseCase>();
final signInUseCase = locator<SignInUseCase>();
