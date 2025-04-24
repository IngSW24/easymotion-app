import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to Easymotion"),
        ),
        body: LoadingIndicator());
  }
}
