import 'dart:async';

import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';

final class GetWalletListUseCase
    extends BaseNoParamUseCase<Result<List<WalletEntity>>> {
  final WalletRepository _repository;

  GetWalletListUseCase(this._repository);

  @override
  FutureOr<Result<List<WalletEntity>>> call() {
    // TODO: implement call
    throw UnimplementedError();
  }
}
