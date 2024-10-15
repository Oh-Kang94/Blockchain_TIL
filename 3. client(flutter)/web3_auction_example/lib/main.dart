import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/env/flavor.dart';
import 'package:web3_auction_example/app/router/router.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/presentation/home.dart';
import 'package:web3_auction_example/presentation/pages/base/responsive_layout.dart';

Future<void> runFlavoredApp() async {
  await Flavor.instance.setupAll();

  return runApp(
    ProviderScope(
      observers: [
        RiverPodLogger(),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return MaterialApp.router(
          routerConfig: appRouter(ref),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return ResponsiveLayoutBuilder(context, child);
          },
        );
      },
    );
  }
}
