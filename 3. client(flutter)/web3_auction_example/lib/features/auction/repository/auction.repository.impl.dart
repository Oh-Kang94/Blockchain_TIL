import 'package:web3_auction_example/core/datasource/remote/web3.datasource.dart';
import 'package:web3_auction_example/core/extensions/big_int.extensions.dart';
import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/auction/entities/bid.entity.dart';
import 'package:web3_auction_example/features/auction/repository/auction.repository.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction.dto.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction_create_event.dto.dart';
import 'package:web3_auction_example/features/auction/repository/model/bid_created_event.dto.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';
import 'package:web3dart/web3dart.dart';

class AuctionRepositoryImpl with _Private implements AuctionRepository {
  final Web3Datasource _web3datasource;
  final WalletRepository _walletRepository;

  AuctionRepositoryImpl(this._web3datasource, this._walletRepository);

  @override
  Future<Result<(AuctionCreateEventDto, BigInt)>> createAuction({
    required AuctionDto auctionDto,
  }) async {
    try {
      // Var
      late final AuctionCreateEventDto eventDto;
      final EthPrivateKey privateKey =
          (await _walletRepository.getActivatePrivateKey()).getOrThrow();
      final DeployedContract contract = await _web3datasource.getContract();

      // #0 Set Event Stream Configuration
      final ContractEvent auctionEvent = contract.event('AuctionCreated');
      final filter =
          FilterOptions.events(contract: contract, event: auctionEvent);

      // #1 Make Transaction
      final receipt = await _transitAuctionCreate(
        contract: contract,
        auctionDto: auctionDto,
        privateKey: privateKey,
        web3DataSource: _web3datasource,
      );

      // #2 Get Event Async
      final eventStream =
          _web3datasource.client.events(filter).take(1); // 첫 번째 이벤트만 받도록 설정

      await for (final event in eventStream) {
        final decoded = auctionEvent.decodeResults(event.topics!, event.data!);
        CLogger.i(decoded);
        final listingId = decoded[0] as BigInt;
        final seller = decoded[1] as EthereumAddress;
        final price = decoded[2] as BigInt;
        final tokenId = decoded[3] as BigInt;
        final startAt = decoded[4] as BigInt;
        final endAt = decoded[5] as BigInt;

        eventDto = AuctionCreateEventDto(
          listingId: listingId,
          seller: seller,
          price: price,
          tokenId: tokenId,
          startAt: startAt,
          endAt: endAt,
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

  @override
  Future<Result<List<BidEntity>>> getBidListByTokenId({
    required String tokenId,
  }) async {
    try {
      // #0 SetUp
      final contract = await _web3datasource.getContract();
      final ContractFunction function =
          contract.function('getActiveAuctionsForToken');

      // #1 Get Result Raw
      final resultRaw = (await _web3datasource.client.call(
        contract: contract,
        function: function,
        params: [BigInt.from(int.parse(tokenId))],
      ));
      // #2 Raw => List<BidEntity>
      final result = (resultRaw[0] as List).map<BidEntity>((values) {
        return BidEntity.fromRaw(values);
      }).toList(); // 'map' 결과를 리스트로 변환

      return Result.success(result);
    } catch (e) {
      return Result.failure(NetworkException(e.toString()));
    }
  }

  @override
  Future<Result<(BidCreatedEventDto, BigInt)>> bidAuction({
    required BigInt biddingPrice,
    required BigInt listingId,
  }) async {
    try {
      // Var
      final EthPrivateKey privateKey =
          (await _walletRepository.getActivatePrivateKey()).getOrThrow();
      final DeployedContract contract = await _web3datasource.getContract();
      late final BidCreatedEventDto eventDto;

      // #0 Set Event Stream Configuration
      final ContractEvent auctionEvent = contract.event('AuctionCreated');
      final filter =
          FilterOptions.events(contract: contract, event: auctionEvent);

      // #1 Make Transaction
      final receipt = await _transitBid(
        contract: contract,
        biddingPrice: biddingPrice,
        listingId: listingId,
        privateKey: privateKey,
        web3DataSource: _web3datasource,
      );

      // #2 Get Event Async
      final eventStream =
          _web3datasource.client.events(filter).take(1); // 첫 번째 이벤트만 받도록 설정

      await for (final event in eventStream) {
        final decoded = auctionEvent.decodeResults(event.topics!, event.data!);
        CLogger.i(decoded);
        final listingId = decoded[0] as BigInt;
        final bidder = decoded[1] as EthereumAddress;
        final bid = decoded[2] as BigInt;

        eventDto = BidCreatedEventDto(
          listingId: listingId,
          bidder: bidder,
          bid: bid,
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

mixin class _Private {
  Future<TransactionReceipt?> _transitAuctionCreate({
    required DeployedContract contract,
    required AuctionDto auctionDto,
    required EthPrivateKey privateKey,
    required Web3Datasource web3DataSource,
  }) async {
    Transaction tx = Transaction.callContract(
      contract: contract,
      function: contract.function('createAuctionListing'), // FROM abi
      parameters: [
        auctionDto.price,
        auctionDto.tokenId,
        auctionDto.durationInSeconds,
      ],
    );
    final txHash = await web3DataSource.client.sendTransaction(
      privateKey,
      tx,
      chainId: web3DataSource.chainId,
    );
    return await web3DataSource.client.getTransactionReceipt(txHash);
  }

  Future<TransactionReceipt?> _transitBid({
    required DeployedContract contract,
    required BigInt biddingPrice,
    required BigInt listingId,
    required EthPrivateKey privateKey,
    required Web3Datasource web3DataSource,
  }) async {
    Transaction tx = Transaction.callContract(
      contract: contract,
      function: contract.function('bid'), // FROM abi
      parameters: [listingId],
      value: EtherAmount.fromBigInt(EtherUnit.wei, biddingPrice),
    );
    final txHash = await web3DataSource.client.sendTransaction(
      privateKey,
      tx,
      chainId: web3DataSource.chainId,
    );
    return await web3DataSource.client.getTransactionReceipt(txHash);
  }
}
