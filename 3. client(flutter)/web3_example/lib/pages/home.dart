import 'package:flutter/material.dart';
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

  EtherAmount? _userBalance;

  String? _contractBalance;

  @override
  void initState() {
    fundraising = Fundraising();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _userBalance = await fundraising.checkBalance();
      setState(() {});
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
            const Text("Address"),
            Text(
              Web3Datasource().contributor.address.toString(),
            ),
            _spacer,
            const Text("Balance"),
            Text('${_userBalance?.getValueInUnit(EtherUnit.ether)} ETH'),
            _spacer,
            ElevatedButton(
              onPressed: () async {
                _contractBalance = await fundraising.getBalance();
                setState(() {});
              },
              child: const Text('Get Balance'),
            ),
            Visibility(
              visible: _contractBalance != null,
              child: Text('Contract Balance : ${(_contractBalance ?? '')} eth'),
            ),
            _spacer,
            ElevatedButton(
              onPressed: () async {
                await fundraising.donateEth();
                _contractBalance = await fundraising.getBalance();
                _userBalance = await fundraising.checkBalance();
                setState(() {});
              },
              child: const Text('Donate 1 ETH'),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _spacer {
    return const SizedBox(
      height: 30,
    );
  }
}
