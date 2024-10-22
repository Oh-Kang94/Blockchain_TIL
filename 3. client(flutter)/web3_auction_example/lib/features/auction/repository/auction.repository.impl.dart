import 'package:web3_auction_example/core/datasource/remote/web3.datasource.dart';
import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/auction/repository/auction.repository.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction.dto.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction_create_event.dto.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';
import 'package:web3dart/web3dart.dart';

class AuctionRepositoryImpl implements AuctionRepository {
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
      final receipt = await _makeTransaction(
        contract: contract,
        auctionDto: auctionDto,
        privateKey: privateKey,
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

  Future<TransactionReceipt?> _makeTransaction({
    required DeployedContract contract,
    required AuctionDto auctionDto,
    required EthPrivateKey privateKey,
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
    final txHash = await _web3datasource.client.sendTransaction(
      privateKey,
      tx,
      chainId: _web3datasource.chainId,
    );
    return await _web3datasource.client.getTransactionReceipt(txHash);
  }
}
