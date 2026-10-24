import 'package:flutter/material.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel();
}

class MapView extends StatelessWidget {
  const MapView({super.key, required this.viewModel});

  final MapViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('地圖'),
          Text('尚未推出'),
        ],
      ),
    );
  }
}
