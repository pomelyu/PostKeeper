import 'package:flutter/material.dart';

class KeeperViewModel extends ChangeNotifier {
  KeeperViewModel();
}

class KeeperView extends StatelessWidget {
  const KeeperView({super.key, required this.viewModel});

  final KeeperViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('收藏'),
          Text('尚未推出'),
        ],
      ),
    );
  }
}
