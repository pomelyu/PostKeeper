import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';

// flutter test integration_test/google_maps_test.dart -d <iOS-device-id>
// Map creation checks SDK integration. Also check the displayed base map and
// native logs for API authorization errors; creation alone does not verify a key.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Google Maps SDK creates a map', (tester) async {
    final created = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoogleMap(
            key: const ValueKey('google-maps-smoke-test'),
            initialCameraPosition: const CameraPosition(
              target: LatLng(25.0476133, 121.5174062),
              zoom: 14,
            ),
            onMapCreated: (_) => created.complete(),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => created.future.timeout(const Duration(seconds: 30)),
    );
    expect(created.isCompleted, isTrue);
    // Leave time for the live base map to render for manual verification.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 5)),
    );
  }, skip: kIsWeb || defaultTargetPlatform != TargetPlatform.iOS);
}
