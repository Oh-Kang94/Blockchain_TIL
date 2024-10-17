import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3_auction_example/features/auth/entities/wallet.entity.dart';

/// ### `Singleton Class`
class IsarDataSource {
  // 싱글톤 패턴을 사용하여 인스턴스를 하나만 생성하는 생성자
  IsarDataSource._internal();

  // IsarDataSource의 유일한 인스턴스를 생성 (싱글톤 인스턴스)
  static final IsarDataSource _instance = IsarDataSource._internal();

  // 외부에서 IsarDataSource를 호출할 때마다 동일한 인스턴스를 반환하는 factory 생성자
  factory IsarDataSource() {
    return _instance;
  }

  // Isar 데이터베이스 인스턴스를 비동기로 관리하기 위한 변수 (초기에는 null)
  Future<Isar>? _db;

  // 데이터베이스 인스턴스가 없으면 초기화하고 반환, 있으면 기존 인스턴스를 반환
  Future<Isar> get db async {
    _db ??= _initDb(); // _db가 null이면 _initDb()로 초기화
    return await _db!; // 초기화된 데이터베이스 인스턴스를 반환
  }

  // 데이터베이스를 초기화하는 함수
  Future<Isar> _initDb() async {
    final dir = await getApplicationDocumentsDirectory(); // 앱의 로컬 디렉터리 경로를 가져옴
    final isar = await Isar.open(
      // Isar 데이터베이스를 스키마와 함께 오픈
      [
        WalletEntitySchema,
      ],
      directory: dir.path, // 데이터베이스 파일이 저장될 디렉터리 경로
    );

    // await _initializeCallbackSetting(isar); // 초기 설정 값이 없으면 기본 값으로 세팅

    return isar; // 초기화된 Isar 인스턴스를 반환
  }

  // 외부에서 호출 가능한 데이터베이스 초기화 함수 (db를 사용하도록 보장)
  Future<void> initialize() async {
    await db; // db getter를 호출하여 데이터베이스를 초기화
  }

  /// CallbackSetting을 초기화하는 함수
  ///
  /// 첫 앱 시동이면 아무런 값이 없기때문에, 기본값 넣기 위해서
  // Future<void> _initializeCallbackSetting(Isar isar) async {
  //   // 기존 CallbackSetting이 없으면 기본 값을 설정
  //   final existingSettings = await isar.callbackSettings.where().findAll();
  //   if (existingSettings.isEmpty) {
  //     final defaultSetting = CallbackSetting.init(); // 기본 설정을 초기화
  //     await isar.writeTxn(() async {
  //       // 트랜잭션 내에서 쓰기 작업을 수행
  //       await isar.callbackSettings.put(defaultSetting); // 기본 설정을 데이터베이스에 저장
  //     });
  //   }
  // }
}
