import 'dart:convert';
import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postkeeper/domain/models/postcard.dart';

/// Groups nearby postcard positions in map pixels at the current zoom level.
class PostcardMapCluster {
  PostcardMapCluster(Postcard postcard) : postcards = [postcard];

  final List<Postcard> postcards;
  LatLng get position => LatLng(
    postcards.first.sendFrom.latitude!,
    postcards.first.sendFrom.longitude!,
  );
  String get id => jsonEncode(postcards.map((card) => card.id).toList());

  static double mercatorY(double latitude) {
    final sin = math.sin(
      latitude.clamp(-85.05112878, 85.05112878) * math.pi / 180,
    );
    return 0.5 - math.log((1 + sin) / (1 - sin)) / (4 * math.pi);
  }

  static List<PostcardMapCluster> group(List<Postcard> postcards, double zoom) {
    final clusters = <PostcardMapCluster>[];
    final scale = 256 * math.pow(2, zoom);
    for (final card in postcards) {
      final point = LatLng(card.sendFrom.latitude!, card.sendFrom.longitude!);
      PostcardMapCluster? nearby;
      for (final cluster in clusters) {
        final longitude = (point.longitude - cluster.position.longitude).abs();
        final dx = math.min(longitude, 360 - longitude) / 360 * scale;
        final dy =
            (mercatorY(point.latitude) - mercatorY(cluster.position.latitude)) *
            scale;
        if (dx * dx + dy * dy <= 48 * 48) {
          nearby = cluster;
          break;
        }
      }
      if (nearby == null) {
        clusters.add(PostcardMapCluster(card));
      } else {
        nearby.postcards.add(card);
      }
    }
    return clusters;
  }
}
