import 'package:postkeeper/enums.dart';

import './location.dart';
import './person.dart';

class Postcard {
  Postcard({
    required this.id,
    required this.orientation,
    required this.createdAt,
    required this.updatedAt,
    required this.frontImagePath,
    required this.backImagePath,
    required this.sender,
    required this.recipient,
    required this.sendFrom,
    required this.sendTo,
    required this.isFavorite,
    this.title,
    this.sentAt,
    this.receivedAt,
    this.notes = '',
  });

  final String id;
  final String frontImagePath;
  final String backImagePath;
  final PostcardOrientation orientation;

  final String? title;

  final Person sender;
  final Person recipient;

  final Location sendFrom;
  final Location sendTo;

  final DateTime? sentAt;
  final DateTime? receivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String notes;
  final bool isFavorite;
}
