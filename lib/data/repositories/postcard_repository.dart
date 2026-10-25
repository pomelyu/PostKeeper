import 'package:postkeeper/domain/models/postcard.dart';

abstract interface class PostcardRepository {
  Future<Postcard?> getLatestSentPostcard();
  Future<Postcard?> getLatestReceivedPostcard();
}
