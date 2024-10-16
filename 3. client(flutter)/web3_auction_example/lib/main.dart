import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/env/flavor.dart';
import 'package:web3_auction_example/app/router/router.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_theme.dart';
import 'package:web3_auction_example/core/util/app_size.dart';
import 'package:web3_auction_example/core/util/logger.dart';
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
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          themeMode: ThemeMode.light,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            // App Color from Theme
            AppColor.init(context);
            // App Size
            AppSize.to.init(context);
            return ResponsiveLayoutBuilder(context, child);
          },
        );
      },
    );
  }
}
