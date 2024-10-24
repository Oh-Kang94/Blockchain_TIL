import 'package:web3_auction_example/core/datasource/remote/web3.datasource.dart';
import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/nft/repository/model/minted_event.dto.dart';
import 'package:web3_auction_example/features/nft/repository/model/nft.model.dart';
import 'package:web3_auction_example/features/nft/repository/nft.repository.dart';
import 'package:web3dart/web3dart.dart';

class NftRepositoryImpl with _Private implements NftRepository {
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
      final contract = await _web3datasource.getContract();
      final ContractFunction getInfo = contract.function('getNFTInfo');
      List<Nft> nftList = [];

      if (mintedCount == 0) {
        return Result.success(nftList);
      }

      // 3. 민팅된 토큰 개수만큼 반복하며 각 NFT 정보를 가져옴
      for (int i = 1; i <= mintedCount; i++) {
        final result = await _web3datasource.client.call(
          contract: contract,
          function: getInfo,
          params: [BigInt.from(i)],
        );

        final nft = Nft(
          name: result[0],
          tokenId: result[1].toInt(),
          tokenURI: result[2],
          isAuction: result[3],
          price: result[4],
          owner: result[5].toString(),
        );

        // 4. 리스트에 추가
        nftList.add(nft);
      }

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

  @override
  Future<Result<(MintedEvent, BigInt)>> createNft({
    required String tokenUri,
    required EthPrivateKey privateKey,
  }) async {
    try {
      late final MintedEvent eventDto;
      final DeployedContract contract = await _web3datasource.getContract();
      // #0 Set Event Stream Configuration
      final ContractEvent auctionEvent = contract.event('Minted');
      final filter =
          FilterOptions.events(contract: contract, event: auctionEvent);

      final receipt = await _makeTransaction(
        contract: contract,
        tokenUri: tokenUri,
        privateKey: privateKey,
        web3datasource: _web3datasource,
      );

      // #2 Get Event Async
      final eventStream = _web3datasource.client.events(filter).take(1);

      await for (final event in eventStream) {
        final decoded = auctionEvent.decodeResults(event.topics!, event.data!);
        CLogger.i(decoded);
        final minterAddress = decoded[0] as EthereumAddress;
        final tokenId = decoded[1] as BigInt;
        final tokenURI = decoded[2] as String;

        eventDto = MintedEvent(
          minterAddress: minterAddress,
          tokenId: tokenId,
          tokenURI: tokenURI,
        );
      }

      // #3 Get GasFee From TX
      if (receipt != null) {
        final BigInt? gasUsed = receipt.gasUsed; // 사용된 가스량
        final BigInt effectiveGasPrice = receipt.effectiveGasPrice!
            .getValueInUnitBI(EtherUnit.gwei); // 가스 가격 (wei 단위)

        // 가스비 계산
        final BigInt gasCost = gasUsed! * effectiveGasPrice; // 가스비 (wei 단위)

        return Result.success((eventDto, gasCost));
      }
      return Result.failure(const UndefinedException(''));
    } catch (e) {
      return Result.failure(NetworkException(e.toString()));
    }
  }
}

// Private
mixin class _Private {
  Future<TransactionReceipt?> _makeTransaction({
    required DeployedContract contract,
    required String tokenUri,
    required EthPrivateKey privateKey,
    required Web3Datasource web3datasource,
  }) async {
    Transaction tx = Transaction.callContract(
      contract: contract,
      function: contract.function('mint'), // FROM abi
      parameters: [
        tokenUri,
        privateKey.address,
      ],
    );
    final txHash = await web3datasource.client.sendTransaction(
      privateKey,
      tx,
      chainId: web3datasource.chainId,
    );
    return await web3datasource.client.getTransactionReceipt(txHash);
  }
}
