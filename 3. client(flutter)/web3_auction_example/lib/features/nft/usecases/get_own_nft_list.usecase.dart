import 'dart:async';

import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';
import 'package:web3_auction_example/features/nft/repository/model/nft.model.dart';
import 'package:web3_auction_example/features/nft/repository/nft.repository.dart';

class GetOwnNftListUseCase
    extends BaseUseCase<String, Result<List<NftEntity>>> {
  final NftRepository _nftRepository;

  GetOwnNftListUseCase(this._nftRepository);
  
  @override
  FutureOr<Result<List<NftEntity>>> call(String request) async {
    final List<NftEntity> resultList = [];
    final List<Nft> nftListRaw = (await _nftRepository.getNftList()).fold(
      onSuccess: (List<Nft> values) {
        return values;
      },
      onFailure: (e) {
        throw Result.failure(e);
      },
    );
    final nftList = nftListRaw
        .where(
          (element) => element.owner == request,
        )
        .toList();
    for (var value in nftList) {
      resultList.add(value.toEntity());
    }
    return Result.success(resultList);
  }
}
