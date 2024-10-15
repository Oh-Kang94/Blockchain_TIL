import 'package:web3_auction_example/app/env/env.enum.dart';
import 'package:web3_auction_example/app/env/flavor.dart';
import 'package:web3_auction_example/main.dart';

void main() async {
  Flavor.initialize(Env.localhost);
  return runFlavoredApp();
}
