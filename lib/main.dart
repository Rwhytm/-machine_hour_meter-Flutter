import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_meter/menu.dart';

//fungsi utama untuk android
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

//Material app dari android
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Machine Hour Metter',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0, // This removes the shadow from all App Bars.
        ),
        primarySwatch: Colors.blue,
      ),
      home: const Menu(),
    );
  }
}
