import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/features/nft/repository/model/nft.dart';

abstract interface class NftRepository {
  /// get nft List
  Future<Result<List<Nft>>> getNftList();
}
