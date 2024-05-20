import 'package:clario_flutter_test/features/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MainApp());

const _appTitle = 'Flutter test task';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _appTitle,
      home: SignUpPage(),
    );
  }
}
