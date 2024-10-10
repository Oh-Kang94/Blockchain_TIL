import 'package:flutter/material.dart';
import 'package:web3_example/components/dialog.dart';
import 'package:web3_example/controller/fundraising.dart';
import 'package:web3_example/controller/web3.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Fundraising fundraising;

  EthereumAddress? _contributor;
  EthereumAddress? _owner;
  EthereumAddress? _contract;
  EtherAmount? _contributorBalance;
  EtherAmount? _ownerBalance;
  EtherAmount? _contractBalance;

  @override
  void initState() {
    Web3Datasource web3 = Web3Datasource();
    fundraising = Fundraising();
    _owner = web3.owner.address;
    _contributor = web3.contributor.address;
    _contract = fundraising.contractAddress;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Owner Address"),
            Text(
              _owner.toString(),
            ),
            _spacer,
            const Text("Contributor Balance"),
            Text('${_ownerBalance?.getValueInUnit(EtherUnit.ether)} ETH'),
            _spacer,
            const Text("Contributor Address"),
            Text(
              _contributor.toString(),
            ),
            _spacer,
            const Text("Contributor Balance"),
            Text('${_contributorBalance?.getValueInUnit(EtherUnit.ether)} ETH'),
            _spacer,
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Get Balance'),
            ),
            Visibility(
              visible: _contractBalance != null,
              child: Text(
                  'Contract Balance : ${_contractBalance?.getValueInUnit(EtherUnit.ether)} eth'),
            ),
            _spacer,
            ElevatedButton(
              onPressed: () async {
                final result = await fundraising.donateEth();
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String? gasFee;
                      if (result.$2 != null) {
                        gasFee =
                            EtherAmount.fromBigInt(EtherUnit.gwei, result.$2!)
                                .getValueInUnit(EtherUnit.ether)
                                .toString();
                      }
                      return CustomDialog(
                        result: result.$1,
                        child: result.$1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Success"),
                                  Text("Gas Fee : $gasFee Eth")
                                ],
                              )
                            : const Text("Fail"),
                      );
                    },
                  ).then(
                    (value) async {
                      value ? await _fetchData() : null;
                    },
                  );
                }
              },
              child: const Text('Donate 1 ETH'),
            ),
            _spacer,
            ElevatedButton(
              onPressed: () async {
                final result = await fundraising.withdrawDonations(sender: _owner);
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                        result: result.$1,
                        child: result.$1
                            ? const Text("Success")
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Fail"),
                                  Text("Reason : ${result.$2}")
                                ],
                              ),
                      );
                    },
                  ).then(
                    (value) async {
                      value ? await _fetchData() : null;
                    },
                  );
                }
              },
              child: const Text('WithdrawDonations'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
    _contractBalance = await fundraising.checkBalance(_contract!);
    _contributorBalance = await fundraising.checkBalance(_contributor!);
    _ownerBalance = await fundraising.checkBalance(_owner!);
    setState(() {});
  }

  Widget get _spacer {
    return const SizedBox(
      height: 30,
    );
  }
}
