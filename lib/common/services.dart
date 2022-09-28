// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  static Future timerSave(
    int hour,
    int minutes,
    int seconds,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('timer').add({
        "hour": hour,
        "minutes": minutes,
        "seconds": seconds,
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
