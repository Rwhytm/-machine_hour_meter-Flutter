// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  static Future timerSave(
    String timer,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('timer').add({
        "timer": timer,
        "createdAt": DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  static Future pauseTime() async {
    try {} catch (e) {
      print(e);
    }
  }
}
