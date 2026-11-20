import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// flutter test integration_test/google_geocoding_test.dart -d <iOS-device-id>
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Geocoding returns an address and country for coordinates', (
    tester,
  ) async {
    final place = await const MethodChannel('postkeeper/places')
        .invokeMapMethod<String, dynamic>('reverseGeocode', {
          'latitude': 25.0476133,
          'longitude': 121.5174062,
        })
        .timeout(const Duration(seconds: 20));
    expect(place, isNotNull);
    expect(
      place!['address'],
      isA<String>().having((address) => address.isNotEmpty, 'nonempty', isTrue),
    );
    expect(place['countryCode'], matches(RegExp(r'^[A-Z]{2}$')));
  }, skip: kIsWeb || defaultTargetPlatform != TargetPlatform.iOS);
}
