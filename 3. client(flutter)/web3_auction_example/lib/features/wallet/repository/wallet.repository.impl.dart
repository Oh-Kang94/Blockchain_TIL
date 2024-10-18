import 'dart:math';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import 'package:web3_auction_example/core/datasource/local/isar.datasource.dart';
import 'package:web3_auction_example/core/datasource/local/secure_storage.datasource.dart';
import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/service/address.service.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/model/signin.dto.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final IsarDataSource _localDatasource;
  final SecureStorageDatasource _secureStorage;
  final AddressService _addressService;

  WalletRepositoryImpl(
    this._localDatasource,
    this._secureStorage,
    this._addressService,
  );

  final Uuid uuid = const Uuid();

  @override
  Future<Result<WalletEntity>> createUserInfo({
    required SignInDto signin,
  }) async {
    final isar = await _localDatasource.db;
    try {
      final String address =
          (await _addressService.getPublicAddress(signin.privateKey))
              .toString();
      int uniqueKey = _generateUniqueInt();
      _secureStorage.setSecure(
        key: uniqueKey.toString(),
        value: signin.privateKey,
      );
      final WalletEntity walletEntity = WalletEntity(
        privateKey: uniqueKey,
        name: signin.name,
        address: address,
        isActivate: true,
        createdAt: DateTime.now(),
      );
      await isar.writeTxn(
        () async {
          isar.walletEntitys.put(walletEntity);
        },
      );
      return Result.success(walletEntity);
    } catch (e) {
      CLogger.e(e);
      return Result.failure(const DatabaseException());
    }
  }

  @override
  Future<Result<List<WalletEntity>>> getWallets() async {
    final isar = await _localDatasource.db;
    try {
      List<WalletEntity> walletList =
          await isar.walletEntitys.where().findAll();
      return Result.success(walletList);
    } catch (e) {
      CLogger.e(e);
      return Result.failure(const DatabaseException());
    }
  }

  @override
  Future<Result<WalletEntity>> updateUserInfo({required WalletEntity wallet}) {
    throw UnimplementedError();
  }

  int _generateUniqueInt() {
    var random = Random();
    return random.nextInt(pow(2, 32).toInt()); // 64비트 정수 생성
  }

  @override
  Future<Result<WalletEntity>> getActivateWallet() async {
    final isar = await _localDatasource.db;
    try {
      final WalletEntity? wallet = await isar.walletEntitys
          .where()
          .filter()
          .isActivateEqualTo(true)
          .findFirst();
      if (wallet == null) {
        return Result.failure(const UnauthorizedException());
      }
      return Result.success(wallet);
    } catch (e) {
      CLogger.i(e);
      return Result.failure(const DatabaseException());
    }
  }
}
