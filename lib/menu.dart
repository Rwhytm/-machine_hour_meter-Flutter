import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final referencesData = FirebaseDatabase.instance
      .ref()
      .child('https://yang-terbaru-default-rtdb.firebaseio.com/')
      .child('arus listrik');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: referencesData.onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data);
              }
            },
          ),
        ),
      ),
    );
  }
}
