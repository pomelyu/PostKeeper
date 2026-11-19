import Flutter
import GooglePlaces
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "PostKeeperPlaces") else { return }
    let channel = FlutterMethodChannel(name: "postkeeper/places", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      guard call.method == "autocomplete" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let arguments = call.arguments as? [String: Any],
            let query = arguments["query"] as? String, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        result(FlutterError(code: "invalid_query", message: "A search query is required.", details: nil))
        return
      }
      guard let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String,
            !key.isEmpty, !key.contains("$(") else {
        result(FlutterError(code: "missing_key", message: "Set GOOGLE_MAPS_API_KEY in Secrets.xcconfig.", details: nil))
        return
      }
      GMSPlacesClient.provideAPIKey(key)
      GMSPlacesClient.shared().fetchAutocompleteSuggestions(from: GMSAutocompleteRequest(query: query)) { suggestions, error in
        if error != nil {
          result(FlutterError(code: "places_error", message: "Places autocomplete failed. Check API access and network.", details: nil))
          return
        }
        result(suggestions?.compactMap { suggestion -> [String: String]? in
          guard let place = suggestion.placeSuggestion else { return nil }
          return ["placeId": place.placeID, "text": place.attributedFullText.string]
        } ?? [])
      }
    }
  }
}
