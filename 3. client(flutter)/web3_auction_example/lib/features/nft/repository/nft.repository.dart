import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/features/nft/repository/model/minted_event.dto.dart';
import 'package:web3_auction_example/features/nft/repository/model/nft.model.dart';
import 'package:web3dart/web3dart.dart';

abstract interface class NftRepository {
  // get How Many Minted
  Future<Result<int>> getHowManyMinted();

  /// get nft List
  Future<Result<List<Nft>>> getNftList();

  /// Mint Nft
  Future<Result<(MintedEvent, BigInt)>> createNft({
    required String tokenUri,
    required EthPrivateKey privateKey,
  });
}
