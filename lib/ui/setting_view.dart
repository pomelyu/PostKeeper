import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier {
  SettingViewModel();
}

class SettingView extends StatelessWidget {
  const SettingView({super.key, required this.viewModel});

  final SettingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('設定'),
          Text('尚未推出'),
        ],
      ),
    );
  }
}
