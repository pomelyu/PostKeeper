import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel();
}

class MainView extends StatelessWidget {
  const MainView({super.key, required this.viewModel});

  final MainViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('首頁'),
          Text('尚未推出'),
        ],
      ),
    );
  }
}
