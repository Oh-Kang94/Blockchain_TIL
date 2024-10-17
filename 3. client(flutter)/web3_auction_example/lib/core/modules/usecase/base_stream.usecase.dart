import 'package:flutter/foundation.dart';

abstract class BaseStreamUseCase<REQUEST, RESPONSE> {
  Stream<RESPONSE> call(REQUEST request);

  BaseStreamUseCase() {
    onInit();
  }

  @protected
  void onInit() {}
}

abstract class BaseNoParamStreamUseCase<RESPONSE> {
  Stream<RESPONSE> call();

  BaseNoParamStreamUseCase() {
    onInit();
  }

  @protected
  void onInit() {}
}
