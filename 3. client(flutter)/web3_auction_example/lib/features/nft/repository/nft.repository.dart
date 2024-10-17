import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/features/nft/repository/model/nft.model.dart';

abstract interface class NftRepository {
  // get How Many Minted
  Future<Result<int>> getHowManyMinted();

  /// get nft List
  Future<Result<List<Nft>>> getNftList();
}