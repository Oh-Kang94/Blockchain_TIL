import 'dart:async';

import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/nft/repository/model/minted_event.dto.dart';
import 'package:web3_auction_example/features/nft/repository/nft.repository.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';
import 'package:web3dart/web3dart.dart';

class MintNftUsecase
    extends BaseUseCase<String, Result<(MintedEvent, BigInt)>> {
  final NftRepository _nftRepository;
  final WalletRepository _walletRepository;

  MintNftUsecase(this._nftRepository, this._walletRepository);

  @override
  FutureOr<Result<(MintedEvent, BigInt)>> call(String request) async {
    try {
      final EthPrivateKey privateKey =
          (await _walletRepository.getActivatePrivateKey()).fold(
        onSuccess: (value) => value,
        onFailure: (e) => throw Exception(e),
      );

      return await _nftRepository.createNft(
        tokenUri: request,
        privateKey: privateKey,
      );
    } catch (e) {
      return Result.failure(NetworkException(e.toString()));
    }
  }
}
