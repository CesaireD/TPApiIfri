import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '';

  final firstPage = token == '' ? 'LOGIN' : 'HOME';

  runApp(MyApp(firstPage: firstPage));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.firstPage});

  final String firstPage;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: firstPage == 'LOGIN' ? const LoginScreen() : const HomeScreen(),
    );
  }
}