import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class BaseUseCase<REQUEST, RESPONSE> {
  FutureOr<RESPONSE> call(REQUEST request);

  BaseUseCase() {
    onInit();
  }

  @protected
  void onInit() {}
}

abstract class BaseNoParamUseCase<RESPONSE> {
  FutureOr<RESPONSE> call();

  BaseNoParamUseCase() {
    onInit();
  }

  @protected
  void onInit() {}
}
