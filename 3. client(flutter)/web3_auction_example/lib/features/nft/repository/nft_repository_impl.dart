import 'package:web3_auction_example/core/datasource/remote/web3_datasource.dart';
import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/nft/repository/model/nft.dart';
import 'package:web3_auction_example/features/nft/repository/nft_repository.dart';
import 'package:web3dart/web3dart.dart';

class NftRepositoryImpl implements NftRepository {
  final Web3Datasource _web3datasource;

  NftRepositoryImpl(this._web3datasource);

  @override
  Future<Result<List<Nft>>> getNftList() async {
    late int mintedCount;
    try {
      // 1. getHowManyMinted 실행
      final mintedResult = await getHowManyMinted();

      mintedCount = mintedResult.fold(
        onSuccess: (value) => value,
        onFailure: (e) => throw e,
      );
      CLogger.i("Minted Count : $mintedCount");

      final contract = await _web3datasource.getContract();
      final ContractFunction getInfo = contract.function('getNFTInfo');
      List<Nft> nftList = [];

      // 3. 민팅된 토큰 개수만큼 반복하며 각 NFT 정보를 가져옴
      for (int i = 1; i <= mintedCount; i++) {
        final result = await _web3datasource.client.call(
          contract: contract,
          function: getInfo,
          params: [BigInt.from(i)],
        );

        final priceRaw = EtherAmount.fromBigInt(EtherUnit.ether, result[4]);
        final nft = Nft(
          name: result[0],
          tokenId: result[1].toInt(),
          tokenURI: result[2],
          isAuction: result[3],
          price: priceRaw.getValueInUnit(EtherUnit.wei),
          owner: result[5].toString(),
        );

        // 4. 리스트에 추가
        nftList.add(nft);
      }
      CLogger.i(nftList);

      // 5. 모든 NFT 정보를 담은 리스트 반환
      return Result.success(nftList);
    } catch (e) {
      CLogger.e(e);
      return Result.failure(
        CustomException.network(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<int>> getHowManyMinted() async {
    try {
      final contract = await _web3datasource.getContract();
      final ContractFunction getHowManyMinted =
          contract.function('getHowManyMinted');
      final result = await _web3datasource.client.call(
        contract: contract,
        function: getHowManyMinted,
        params: [],
      );

      return Result.success(result[0].toInt());
    } catch (e) {
      return Result.failure(
        CustomException.network(
          e.toString(),
        ),
      );
    }
  }
}
