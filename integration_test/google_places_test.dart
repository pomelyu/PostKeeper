import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// flutter test integration_test/google_places_test.dart -d <iOS-device-id>
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Places SDK returns search suggestions', (tester) async {
    final suggestions = await const MethodChannel('postkeeper/places')
        .invokeListMethod<dynamic>('autocomplete', {'query': '台北車站'})
        .timeout(const Duration(seconds: 20));
    expect(suggestions, isNotEmpty);
    final first = suggestions!.first as Map;
    expect(
      first['placeId'],
      isA<String>().having((id) => id.isNotEmpty, 'nonempty', isTrue),
    );
    expect(
      first['text'],
      isA<String>().having((text) => text.isNotEmpty, 'nonempty', isTrue),
    );
  }, skip: kIsWeb || defaultTargetPlatform != TargetPlatform.iOS);
}
