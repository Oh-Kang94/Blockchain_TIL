import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3_auction_example/app/env/env.enum.dart';

class Flavor {
  // SingleTon
  Flavor._();
  static final Flavor _instance = Flavor._();

  static late Env _env;

  static Flavor get instance => _instance;
  static Env get env => _env;

  static void initialize(Env type) {
    _env = type;
  }

  // App 실행 하기전에, Env에 따라서, 전체적인 초기화 작업이 여기서 들어간다.
  Future<void> setupAll() async {
    // 비동기 작업 가능 하게 하는 Method
    WidgetsFlutterBinding.ensureInitialized();
    // landscape 막기
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    // 환경 파일 로드
    await dotenv.load(
      fileName: env.dotFileName,
    );

    // TODO : Init IsarDatasource

    // TODO : App DI Initialize

    // TODO : If need, etc
  }
}
