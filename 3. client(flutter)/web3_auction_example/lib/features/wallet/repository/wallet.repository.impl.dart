import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import 'package:web3_auction_example/core/datasource/local/isar.datasource.dart';
import 'package:web3_auction_example/core/datasource/local/secure_storage.datasource.dart';
import 'package:web3_auction_example/core/datasource/remote/web3.datasource.dart';
import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/service/address.service.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/model/signin.dto.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';
import 'package:web3dart/web3dart.dart';

class WalletRepositoryImpl with _Private implements WalletRepository {
  final IsarDataSource _localDatasource;
  final SecureStorageDatasource _secureStorage;
  final AddressService _addressService;
  final Web3Datasource _web3datasource;

  WalletRepositoryImpl(
    this._localDatasource,
    this._secureStorage,
    this._addressService,
    this._web3datasource,
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
      int uniqueKey = _generateUniqueInt(signin.privateKey);

      _secureStorage.setSecure(
        key: uniqueKey.toString(),
        value: signin.privateKey,
      );

      final balanceRaw = await getBalance(address);
      final balance = balanceRaw.fold(
        onSuccess: (value) {
          return value;
        },
        onFailure: (e) => null,
      );

      final WalletEntity walletEntity = WalletEntity(
        privateKey: uniqueKey,
        name: signin.name,
        address: address,
        amount: balance ?? 0,
        isActivate: true,
        createdAt: DateTime.now(),
      );

      await _updateQuery(isar, walletEntity);

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
  Future<Result<WalletEntity>> updateUserInfo({
    required WalletEntity wallet,
  }) async {
    final isar = await _localDatasource.db;
    try {
      wallet = wallet.copyWith(
        updatedAt: DateTime.now(),
      );
      await _updateQuery(isar, wallet);
      return Result.success(wallet);
    } catch (e) {
      return Result.failure(const DatabaseException());
    }
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

      final newEtherAmount = (await getBalance(wallet.address)).getOrThrow();
      final newWallet = wallet.copyWith(amount: newEtherAmount);

      await updateUserInfo(wallet: newWallet);

      return Result.success(newWallet);
    } catch (e) {
      CLogger.i(e);
      return Result.failure(const DatabaseException());
    }
  }

  @override
  Future<Result<WalletEntity>> activateWallet({
    required WalletEntity activatedWallet,
  }) async {
    final isar = await _localDatasource.db;
    try {
      await _updateAllDeactivate(isar);
      await _updateQuery(isar, activatedWallet);
      return Result.success(activatedWallet);
    } catch (e) {
      CLogger.e(e);
      return Result.failure(const DatabaseException());
    }
  }

  @override
  Future<Result<double>> getBalance(String address) async {
    EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    try {
      EtherAmount balance = await _web3datasource.client.getBalance(ethAddress);
      return Result.success(balance.getValueInUnit(EtherUnit.ether));
    } catch (e) {
      CLogger.e(e);
      return Result.failure(NetworkException(e.toString()));
    }
  }

  @override
  Future<Result<WalletEntity?>> getWalletByPrivateKey(String privateKey) async {
    final isar = await _localDatasource.db;
    try {
      final int index = _generateUniqueInt(privateKey);
      WalletEntity? wallet = await isar.walletEntitys.get(index);
      if (wallet != null) {
        final amount = await getBalance(wallet.address);
        wallet = wallet.copyWith(
          amount: amount.getOrThrow(),
        );
        await updateUserInfo(wallet: wallet);
      }
      return Result.success(wallet);
    } catch (e) {
      CLogger.e(e);
      return Result.failure(const DatabaseException());
    }
  }

  @override
  Future<Result<EthPrivateKey>> getActivatePrivateKey() async {
    try {
      WalletEntity walletEntity = (await getActivateWallet()).fold(
        onSuccess: (wallet) => wallet,
        onFailure: (e) => throw const DatabaseException(),
      );
      String? privateKey = await _secureStorage.getSecure(
        key: walletEntity.privateKey.toString(),
      );
      if (privateKey != null) {
        return Result.success(EthPrivateKey.fromHex(privateKey));
      }
      return Result.failure(const DatabaseException());
    } catch (e) {
      return Result.failure(const DatabaseException());
    }
  }

  @override
  Future<Result<WalletEntity>> deActivateWallet({
    required WalletEntity activatedWallet,
  }) async {
    final isar = await _localDatasource.db;
    try {
      await _updateQuery(isar, activatedWallet);
      return Result.success(activatedWallet);
    } catch (e) {
      CLogger.e(e);
      return Result.failure(const DatabaseException());
    }
  }

  @override
  Future<Result> deleteWallet({
    required WalletEntity walletEntity,
  }) async {
    final isar = await _localDatasource.db;
    try {
      await isar.writeTxn(() async {
        await isar.walletEntitys.delete(walletEntity.privateKey);
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure(const DatabaseException());
    }
  }
}

mixin _Private {
  int _generateUniqueInt(privateKey) {
    // 개인키 문자열을 SHA-256 해시로 변환
    var bytes = utf8.encode(privateKey);
    var digest = sha256.convert(bytes);

    String hexString = digest.toString().substring(0, 15); // 16자리
    int intValue = int.parse(hexString, radix: 16); // 16진수를 10진수로 변환
    return intValue;
  }

  Future<void> _updateQuery(Isar isar, WalletEntity wallet) async {
    await isar.writeTxn(() async {
      await isar.walletEntitys.put(wallet);
    });
  }

  Future<void> _updateAllDeactivate(Isar isar) async {
    final users = await isar.walletEntitys
        .where()
        .filter()
        .isActivateEqualTo(true)
        .findAll();

    if (users.isEmpty) {
      return;
    }

    await isar.writeTxn(() async {
      final updatedUsers =
          users.map((user) => user.copyWith(isActivate: false)).toList();
      await isar.walletEntitys.putAll(updatedUsers);
    });
  }
}
