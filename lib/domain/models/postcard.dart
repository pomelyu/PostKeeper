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
    this.title,
    this.sender,
    this.recipient,
    this.sentAt,
    this.receivedAt,
    this.notes = '',
  });

  final String id;
  final String frontImagePath;
  final String backImagePath;
  final PostcardOrientation orientation;

  final String? title;

  final Person? sender;
  final Person? recipient;

  final DateTime? sentAt;
  final DateTime? receivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String notes;
}
