import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Env {
  localhost(type: "LOCALHOST"),
  testNet(type: "TESTNET");

  final String type;

  const Env({
    required this.type,
  });

  String get dotFileName => switch (this) {
        localhost => '.env',
        testNet => '.env.test',
      };

  String? get apiKey => switch (this) {
        localhost => dotenv.env['apiKey'],
        testNet => dotenv.env['apiKey'],
      };
}
