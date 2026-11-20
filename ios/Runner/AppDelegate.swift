import Flutter
import GooglePlaces
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var placeSessions: [String: GMSAutocompleteSessionToken] = [:]
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String,
       !key.isEmpty, !key.contains("$(") {
      GMSServices.provideAPIKey(key)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "PostKeeperPlaces") else { return }
    let channel = FlutterMethodChannel(name: "postkeeper/places", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      if call.method == "endSession" {
        if let arguments = call.arguments as? [String: Any], let id = arguments["sessionId"] as? String {
          self.placeSessions.removeValue(forKey: id)
        }
        result(nil)
        return
      }
      if call.method == "placeDetails" {
        self.placeDetails(call, result: result)
        return
      }
      if call.method == "reverseGeocode" {
        self.reverseGeocode(call, result: result)
        return
      }
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
      let request = GMSAutocompleteRequest(query: query)
      if let id = arguments["sessionId"] as? String {
        let token = self.placeSessions[id] ?? GMSAutocompleteSessionToken()
        self.placeSessions[id] = token
        request.sessionToken = token
      }
      GMSPlacesClient.shared().fetchAutocompleteSuggestions(from: request) { suggestions, error in
        if error != nil {
          result(FlutterError(code: "places_error", message: "Places autocomplete failed. Check API access and network.", details: nil))
          return
        }
        result(suggestions?.compactMap { suggestion -> [String: String]? in
          guard let place = suggestion.placeSuggestion else { return nil }
          return ["placeId": place.placeID, "text": place.attributedFullText.string, "primaryText": place.attributedPrimaryText.string]
        } ?? [])
      }
    }
  }

  private func placeDetails(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let arguments = call.arguments as? [String: Any],
          let placeID = arguments["placeId"] as? String, !placeID.isEmpty else {
      result(FlutterError(code: "invalid_place", message: "A place ID is required.", details: nil))
      return
    }
    guard let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String,
          !key.isEmpty, !key.contains("$(") else {
      result(FlutterError(code: "missing_key", message: "Set GOOGLE_MAPS_API_KEY in Secrets.xcconfig.", details: nil))
      return
    }
    GMSPlacesClient.provideAPIKey(key)
    let sessionID = arguments["sessionId"] as? String
    let token = sessionID.flatMap { self.placeSessions[$0] }
    let request = GMSFetchPlaceRequest(
      placeID: placeID,
      placeProperties: [GMSPlaceProperty.coordinate, GMSPlaceProperty.formattedAddress, GMSPlaceProperty.addressComponents].map { $0.rawValue },
      sessionToken: token)
    GMSPlacesClient.shared().fetchPlace(with: request) { place, error in
      guard error == nil, let place = place else {
        result(FlutterError(code: "places_error", message: "Place details failed. Check API access and network.", details: nil))
        return
      }
      let country = place.addressComponents?.first { $0.types.contains("country") }
      result([
        "latitude": place.coordinate.latitude,
        "longitude": place.coordinate.longitude,
        "address": place.formattedAddress ?? "",
        "countryCode": country?.shortName ?? "",
      ])
    }
  }

  private func reverseGeocode(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let arguments = call.arguments as? [String: Double],
          let latitude = arguments["latitude"], let longitude = arguments["longitude"],
          (-90...90).contains(latitude), (-180...180).contains(longitude) else {
      result(FlutterError(code: "invalid_coordinates", message: "Valid coordinates are required.", details: nil))
      return
    }
    guard let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String,
          !key.isEmpty, !key.contains("$(") else {
      result(FlutterError(code: "missing_key", message: "Set GOOGLE_MAPS_API_KEY in Secrets.xcconfig.", details: nil))
      return
    }
    var url = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")!
    url.queryItems = [
      URLQueryItem(name: "latlng", value: "\(latitude),\(longitude)"),
      URLQueryItem(name: "language", value: "zh-TW"),
      URLQueryItem(name: "key", value: key),
    ]
    var request = URLRequest(url: url.url!, timeoutInterval: 15)
    request.setValue(Bundle.main.bundleIdentifier, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
    URLSession.shared.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async {
        guard error == nil,
              (response as? HTTPURLResponse)?.statusCode == 200,
              let data = data,
              let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
          result(FlutterError(code: "geocoding_error", message: "Geocoding request failed.", details: nil))
          return
        }
        guard json["status"] as? String == "OK",
              let places = json["results"] as? [[String: Any]],
              let place = places.first else {
          result(FlutterError(code: "geocoding_error", message: json["status"] as? String ?? "Invalid response", details: nil))
          return
        }
        let components = place["address_components"] as? [[String: Any]] ?? []
        let country = components.first { ($0["types"] as? [String])?.contains("country") == true }
        result([
          "address": place["formatted_address"] as? String ?? "",
          "countryCode": country?["short_name"] as? String ?? "",
        ])
      }
    }.resume()
  }

}
