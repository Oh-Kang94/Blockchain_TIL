import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/model/signin.dto.dart';

abstract class WalletRepository {
  ///
  /// Save PrivateKey With Etc
  ///
  Future<Result<WalletEntity>> createUserInfo({
    required SignInDto signin,
  });

  ///
  /// Save Alias for Wallet
  ///
  Future<Result<WalletEntity>> updateUserInfo({required WalletEntity wallet});

  ///
  /// Get Wallet
  ///
  Future<Result<List<WalletEntity>>> getWallets();
}
