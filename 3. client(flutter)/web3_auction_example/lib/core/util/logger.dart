import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class RiverPodLogger extends ProviderObserver {
  final Logger logger = Logger(
    printer: PrettyPrinter(
      // dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      printEmojis: true,
      colors: false, // ANSI 색상 비활성화
      methodCount: 0,
    ),
  );
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logger.i(
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
    logger.i(
        '''[Provider Added] provider : ${provider.name ?? provider.runtimeType} 
value : ${value.toString()}''');
    super.didAddProvider(provider, value, container);
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    logger.i(
      '[Provider Dispose] provider : ${provider.name ?? provider.runtimeType}',
    );
    super.didDisposeProvider(provider, container);
  }
}
