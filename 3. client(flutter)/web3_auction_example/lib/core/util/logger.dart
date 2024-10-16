import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class CLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      // dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      printEmojis: true,
      colors: false, // ANSI 색상 비활성화
      methodCount: 0,
    ),
  );

  static final Logger _loggerE = Logger(
    printer: PrettyPrinter(
      // dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      printEmojis: true,
      colors: false, // ANSI 색상 비활성화
      methodCount: null,
    ),
  );

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _loggerE.e(message, error: error, stackTrace: stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }
}

class RiverPodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    CLogger.i(
        '''[Provider Updated] provider : ${provider.name ?? provider.runtimeType} 
value: ${newValue.toString()}''');
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    CLogger.i(
        '''[Provider Added] provider : ${provider.name ?? provider.runtimeType} 
value : ${value.toString()}''');
    super.didAddProvider(provider, value, container);
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    CLogger.i(
      '[Provider Dispose] provider : ${provider.name ?? provider.runtimeType}',
    );
    super.didDisposeProvider(provider, container);
  }
}
