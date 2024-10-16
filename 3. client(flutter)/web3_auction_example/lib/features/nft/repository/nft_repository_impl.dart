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
    try {
      final contract = await _web3datasource.getContract();
      final ContractFunction getInfo = contract.function('getNFTInfo');
      final result = await _web3datasource.client.call(
        contract: contract,
        function: getInfo,
        params: [BigInt.from(1)],
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
      return Result.success([nft]);
    } catch (e) {
      CLogger.e(e);
      return Result.failure(
        CustomException.network(
          e.toString(),
        ),
      );
    }
  }
}
