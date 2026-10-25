import 'package:postkeeper/enums.dart';

import './person.dart';

class Postcard {
  Postcard({
    required this.id,
    required this.orientation,
    required this.createdAt,
    required this.updatedAt,
    required this.frontImagePath,
    required this.backImagePath,
    this.sender,
    this.recipient,
    this.sentAt,
    this.receivedAt,
    this.notes = '',
  });

  final String id;
  final Orientation orientation;
  final String frontImagePath;
  final String backImagePath;

  final Person? sender;
  final Person? recipient;

  final DateTime? sentAt;
  final DateTime? receivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String notes;
}
