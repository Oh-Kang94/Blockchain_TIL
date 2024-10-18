import 'package:web3_auction_example/app/di/app_binding.dart';
import 'package:web3_auction_example/core/datasource/local/isar.datasource.dart';
import 'package:web3_auction_example/core/datasource/local/secure_storage.datasource.dart';
import 'package:web3_auction_example/core/datasource/remote/web3.datasource.dart';
import 'package:web3_auction_example/core/service/address.service.dart';
import 'package:web3_auction_example/features/nft/usecases/get_own_nft_list.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/activate_wallet.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/auth.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/get_wallet_list.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/logout.usecase.dart';
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
// NFT
final getNftImageUseCase = locator<GetNftImageUseCase>();
final getOwnNftListUseCase = locator<GetOwnNftListUseCase>();

// wallet 
final signInUseCase = locator<SignInUseCase>();
final authUseCase = locator<AuthUsecase>();
final getWalletListUseCase = locator<GetWalletListUseCase>();
final activateWalletUseCase= locator<ActivateWalletUseCase>();
final logOutUseCase = locator<LogoutUsecase>();