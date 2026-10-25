import 'dart:async';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

// iPhone 15 Pro portrait viewport, measured in logical pixels.
const _iphone15ProSize = Size(393, 852);
const _iphone15ProPixelRatio = 3.0;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final view = binding.platformDispatcher.views.single;

  setUp(() {
    view.devicePixelRatio = _iphone15ProPixelRatio;
    view.physicalSize = _iphone15ProSize * _iphone15ProPixelRatio;
  });

  tearDown(() {
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  await testMain();
}
