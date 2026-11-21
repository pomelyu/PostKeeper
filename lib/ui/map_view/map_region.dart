import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postkeeper/ui/style.dart';

import 'map_view.dart';
import 'postcard_map_cluster.dart';

class MapRegion extends StatefulWidget {
  const MapRegion({super.key, required this.viewModel});
  final MapViewModel viewModel;

  @override
  State<MapRegion> createState() => _MapRegionState();
}

class _MapRegionState extends State<MapRegion> {
  GoogleMapController? _controller;
  int _lastRequest = -1;
  int _viewportRevision = 0;
  bool _pointerDown = false;
  double _zoom = 0;
  Size _size = Size.zero;
  final Map<int, BitmapDescriptor> _countIcons = {};
  final Set<int> _pendingIcons = {};

  @override
  void didUpdateWidget(covariant MapRegion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleFocus();
  }

  void _scheduleFocus() {
    if (_controller == null || _lastRequest == widget.viewModel.cameraRequest) {
      return;
    }
    _lastRequest = widget.viewModel.cameraRequest;
    _viewportRevision++;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.viewModel.countryCode == null) {
        unawaited(_showHome());
        return;
      }
      final points = widget.viewModel.focusPostcards
          .map(
            (card) => LatLng(card.sendFrom.latitude!, card.sendFrom.longitude!),
          )
          .toList();
      if (points.isNotEmpty) unawaited(_fit(MapViewModel.boundsFor(points)));
    });
  }

  Future<void> _showHome() async {
    await _controller?.moveCamera(
      CameraUpdate.newLatLngZoom(widget.viewModel.homeCenter, 0),
    );
    if (mounted) await _onIdle();
  }

  Future<void> _fit(LatLngBounds bounds) async {
    _viewportRevision++;
    if (bounds.southwest == bounds.northeast) {
      await _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(bounds.southwest, 10),
      );
      return;
    }
    // Compute the camera explicitly: native bounds fitting may choose the short
    // arc when the collection spans more than half the world.
    final west = bounds.southwest.longitude;
    final span = (bounds.northeast.longitude - west + 360) % 360;
    final northY = PostcardMapCluster.mercatorY(bounds.northeast.latitude);
    final southY = PostcardMapCluster.mercatorY(bounds.southwest.latitude);
    final zoomX =
        math.log(math.max(1, _size.width - 80) / (256 * span / 360)) / math.ln2;
    final zoomY =
        math.log(math.max(1, _size.height - 80) / (256 * (southY - northY))) /
        math.ln2;
    final mercator = math.pi * (1 - northY - southY);
    final latitude =
        math.atan((math.exp(mercator) - math.exp(-mercator)) / 2) *
        180 /
        math.pi;
    final longitude = (west + span / 2 + 180) % 360 - 180;
    await _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(latitude, longitude),
        math.min(zoomX, zoomY).clamp(0, 19),
      ),
    );
  }

  Future<void> _onIdle() async {
    final revision = ++_viewportRevision;
    final bounds = await _controller?.getVisibleRegion();
    if (!mounted || revision != _viewportRevision || bounds == null) return;
    widget.viewModel.updateVisibleBounds(bounds);
  }

  Future<void> _onClusterTap(PostcardMapCluster cluster) async {
    widget.viewModel.startFreeBrowse();
    final bounds = MapViewModel.boundsFor(
      cluster.postcards.map(
        (card) => LatLng(card.sendFrom.latitude!, card.sendFrom.longitude!),
      ),
    );
    if (bounds.southwest == bounds.northeast) {
      _viewportRevision++;
      await _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(cluster.position, math.min(_zoom + 2, 19)),
      );
    } else {
      await _fit(bounds);
    }
  }

  Future<void> _createCountIcon(int count) async {
    if (!_pendingIcons.add(count)) return;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(3);
    canvas.drawCircle(
      const Offset(24, 24),
      22,
      Paint()..color = surfacePrimaryColor,
    );
    final text = TextPainter(
      text: TextSpan(
        text: '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset(24 - text.width / 2, 24 - text.height / 2));
    final picture = recorder.endRecording();
    final image = await picture.toImage(144, 144);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    picture.dispose();
    if (!mounted || bytes == null) return;
    setState(
      () => _countIcons[count] = BitmapDescriptor.bytes(
        bytes.buffer.asUint8List(),
        width: 36,
        height: 36,
      ),
    );
  }

  @override
  void dispose() {
    _viewportRevision++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      _size = constraints.biggest;
      final clusters = PostcardMapCluster.group(
        widget.viewModel.postcards,
        _zoom,
      );
      final markers = <Marker>{};
      for (final cluster in clusters) {
        final count = cluster.postcards.length;
        if (count > 1 && !_countIcons.containsKey(count)) {
          unawaited(_createCountIcon(count));
        }
        markers.add(
          Marker(
            markerId: MarkerId(cluster.id),
            position: cluster.position,
            icon: count > 1
                ? _countIcons[count] ?? BitmapDescriptor.defaultMarker
                : BitmapDescriptor.defaultMarker,
            anchor: count > 1 ? const Offset(0.5, 0.5) : const Offset(0.5, 1),
            consumeTapEvents: true,
            onTap: count > 1 ? () => _onClusterTap(cluster) : () {},
          ),
        );
      }
      return Listener(
        onPointerDown: (_) => _pointerDown = true,
        onPointerUp: (_) => _pointerDown = false,
        onPointerCancel: (_) => _pointerDown = false,
        child: GoogleMap(
          key: const ValueKey('postcard-map'),
          initialCameraPosition: CameraPosition(
            target: widget.viewModel.homeCenter,
            zoom: 0,
          ),
          markers: markers,
          minMaxZoomPreference: const MinMaxZoomPreference(0, 19),
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          onMapCreated: (controller) {
            _controller = controller;
            _scheduleFocus();
          },
          onCameraMoveStarted: () {
            _viewportRevision++;
            if (_pointerDown) {
              widget.viewModel.startFreeBrowse();
            }
          },
          onCameraMove: (camera) => _zoom = camera.zoom,
          onCameraIdle: _onIdle,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
        ),
      );
    },
  );
}
