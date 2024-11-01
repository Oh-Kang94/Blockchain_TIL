import 'package:web3_auction_example/app/di/app_binding.dart';
import 'package:web3_auction_example/core/datasource/local/isar.datasource.dart';
import 'package:web3_auction_example/core/datasource/local/secure_storage.datasource.dart';
import 'package:web3_auction_example/core/datasource/remote/web3.datasource.dart';
import 'package:web3_auction_example/core/service/address.service.dart';
import 'package:web3_auction_example/features/auction/repository/auction.repository.dart';
import 'package:web3_auction_example/features/auction/usecase/bid_auction.usecase.dart';
import 'package:web3_auction_example/features/auction/usecase/create_auction.usecase.dart';
import 'package:web3_auction_example/features/auction/usecase/get_auction_list_by_token.usecase.dart';
import 'package:web3_auction_example/features/nft/usecases/get_auction_nft_list.usecase.dart';
import 'package:web3_auction_example/features/nft/usecases/get_own_nft_list.usecase.dart';
import 'package:web3_auction_example/features/nft/usecases/mint_nft.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/activate_wallet.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/auth.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/delete_wallet.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/get_wallet_list.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/logout.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/signin.usecase.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';
import 'package:web3_auction_example/features/nft/repository/nft.repository.dart';
import 'package:web3_auction_example/features/nft/usecases/get_nft_list.usecase.dart';
import 'package:web3_auction_example/features/wallet/usecases/update_wallet.usecase.dart';

// DataSource
final web3DataSource = locator<Web3Datasource>();
final isarDatasource = locator<IsarDataSource>();
final secureStorageDatasource = locator<SecureStorageDatasource>();

// Repository && Services
final nftRepository = locator<NftRepository>();
final walletRepository = locator<WalletRepository>();
final addressService = locator<AddressService>();
final auctionRepository = locator<AuctionRepository>();

// Usecases
// Auction
final getAuctionListByTokenUsecase = locator<GetAuctionListByTokenUsecase>();
final createAuctionUseCase = locator<CreateAuctionUseCase>();
final bidAuctionUsecase = locator<BidAuctionUsecase>();

// NFT
final getNftListUseCase = locator<GetNftListUseCase>();
final getOwnNftListUseCase = locator<GetOwnNftListUseCase>();
final getAuctionNftListUseCase = locator<GetAuctionNftListUsecase>();
final getAuctionListByTokenUseCase = locator<GetAuctionNftListUsecase>();

// wallet
final signInUseCase = locator<SignInUseCase>();
final authUseCase = locator<AuthUsecase>();
final getWalletListUseCase = locator<GetWalletListUseCase>();
final activateWalletUseCase = locator<ActivateWalletUseCase>();
final logOutUseCase = locator<LogoutUsecase>();
final mintNftUseCase = locator<MintNftUsecase>();
final updateWalletUseCase = locator<UpdateWalletUsecase>();
final deleteWalletUseCase = locator<DeleteWalletUsecase>();
