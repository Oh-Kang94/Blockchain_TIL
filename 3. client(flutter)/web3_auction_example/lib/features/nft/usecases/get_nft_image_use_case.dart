import 'dart:async';

import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base_use_case.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';
import 'package:web3_auction_example/features/nft/repository/model/nft.dart';
import 'package:web3_auction_example/features/nft/repository/nft_repository.dart';

final class GetNftImageUseCase
    implements BaseNoParamUseCase<Result<List<NftEntity>>> {
  final NftRepository _repository;

  GetNftImageUseCase(this._repository);

  @override
  FutureOr<Result<List<NftEntity>>> call() async {
    final response = await _repository.getNftList();
    return response.fold(
      onSuccess: (List<Nft> values) {
        final List<NftEntity> resultList = [];
        for (var value in values) {
          resultList.add(value.toEntity());
        }
        return Result.success(resultList);
      },
      onFailure: (e) {
        return Result.failure(e);
      },
    );
  }

  @override
  void onInit() {}
}
