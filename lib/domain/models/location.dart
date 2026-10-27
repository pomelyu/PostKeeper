import 'package:postkeeper/constant.dart';

class Location {
  const Location ({
    required this.id,
    required this.name,
    required this.countryCode,
    this.address,
    this.latitude,
    this.longitude,
  }) : assert((latitude == null) == (longitude == null));

  final String id;
  final String name;
  final String countryCode;
  final String? address;

  final double? latitude;
  final double? longitude;
}

final Location dummyLocation = Location(
  id: dummyLocationId,
  name: '',
  countryCode: '',
);
