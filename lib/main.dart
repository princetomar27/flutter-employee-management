import 'package:flutter/material.dart';
import 'package:flutteremployeemanagement/src/core/injector/injection_container.dart'
    as di;
import 'package:flutteremployeemanagement/src/features/authentication/presentation/screen/authentication_screen.dart';
import 'package:flutteremployeemanagement/src/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: AuthenticationScreen(),
    );
  }
}
