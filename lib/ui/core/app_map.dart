import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postkeeper/domain/models/location.dart';

/// Shared Google base map. This view only displays app-provided locations;
/// panning and zooming never trigger Places searches.
class AppMap extends StatefulWidget {
  const AppMap({super.key, this.selected});
  final Location? selected;

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> {
  GoogleMapController? _controller;

  @override
  void didUpdateWidget(covariant AppMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected && widget.selected != null) {
      unawaited(_focus());
    }
  }

  Future<void> _focus() async {
    final location = widget.selected;
    if (location?.latitude == null || location?.longitude == null) return;
    await _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(location!.latitude!, location.longitude!),
        15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.selected;
    return GoogleMap(
      key: const ValueKey('location-picker-map'),
      initialCameraPosition: const CameraPosition(
        target: LatLng(20, 0),
        zoom: 2,
      ),
      onMapCreated: (controller) {
        _controller = controller;
        unawaited(_focus());
      },
      markers: {
        if (location?.latitude != null && location?.longitude != null)
          Marker(
            markerId: const MarkerId('selected-location'),
            position: LatLng(location!.latitude!, location.longitude!),
            infoWindow: InfoWindow(title: location.name),
          ),
      },
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
    );
  }
}
