import 'package:flutter_dotenv/flutter_dotenv.dart';

Exception _exception = Exception('Not found in environment variables.');

enum Env {
  localhost(type: "LOCALHOST"),
  sepolia(type: "SEPOLIA");

  final String type;

  const Env({
    required this.type,
  });

  String get dotFileName => switch (this) {
        localhost => '.env',
        sepolia => '.env.test',
      };

  String get apiKey => dotenv.env['apiKey'] ?? (throw _exception);

  String get rpcUrl => dotenv.env['rpcUrl'] ?? (throw _exception);

  int get chainId =>
      int.tryParse(dotenv.env['chainId'] ?? '') ?? (throw _exception);

  String get contract => dotenv.env['contractAddress'] ?? (throw _exception);

  String get pathName => dotenv.env['db_path'] ?? (throw _exception);
}
