import 'package:flutter/material.dart';
import 'package:flutteremployeemanagement/src/core/injector/injection_container.dart'
    as di;
import 'package:flutteremployeemanagement/src/features/authentication/presentation/screen/authentication_screen.dart';
import 'package:flutteremployeemanagement/src/presentation/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/storage/storage_helper.dart';
import 'src/features/home/presentation/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  Widget _initialScreen = const AuthenticationScreen();

  @override
  void initState() {
    super.initState();
    _checkUserData();
  }

  Future<void> _checkUserData() async {
    final userData = await StorageHelper.getUserData();

    if (userData != null) {
      final prefs = await SharedPreferences.getInstance();
      final lastLoginTime = prefs.getInt('lastLoginTime') ?? 0;
      const oneWeekInMilliseconds = 7 * 24 * 60 * 60 * 1000;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      if (currentTime - lastLoginTime < oneWeekInMilliseconds) {
        setState(() {
          _initialScreen = const HomeScreen();
        });
      } else {
        StorageHelper.clearUserData();
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: _initialScreen,
    );
  }
}
