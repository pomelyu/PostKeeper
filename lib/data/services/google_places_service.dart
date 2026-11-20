import 'package:flutter/services.dart';

class GooglePlacesService {
  const GooglePlacesService();
  static const _channel = MethodChannel('postkeeper/places');

  Future<List<dynamic>> search(String query, String sessionId) async =>
      await _channel
          .invokeListMethod<dynamic>('autocomplete', {
            'query': query,
            'sessionId': sessionId,
          })
          .timeout(const Duration(seconds: 20)) ??
      [];

  Future<Map<String, dynamic>> details(
    String placeId,
    String sessionId,
  ) async =>
      await _channel
          .invokeMapMethod<String, dynamic>('placeDetails', {
            'placeId': placeId,
            'sessionId': sessionId,
          })
          .timeout(const Duration(seconds: 20)) ??
      {};

  Future<void> endSession(String sessionId) =>
      _channel.invokeMethod<void>('endSession', {'sessionId': sessionId});
}
