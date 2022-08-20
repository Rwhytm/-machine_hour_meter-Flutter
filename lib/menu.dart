// ignore_for_file: must_call_super, prefer_const_constructors

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Duration duration = const Duration();
  int index = 0;
  Timer? timer;
  bool isRunning = false;
  bool isDone = false;
  String _textarus = '';
  int arusL = 0;
  String _textdaya = '';
  final referencesData = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    _activeListener();
  }

  void addTime() {
    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void reset() {}

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), ((_) => addTime()));
  }

  void stopTimer({bool resets = true}) {}

  void _activeListener() {
    referencesData.child('arus listrik').onValue.listen((event) {
      final Object? arus = event.snapshot.value;
      setState(() {
        _textarus = arus.toString();
        arusL = int.parse(arus.toString());
      });
    });

    referencesData.child('daya listrik').onValue.listen((event) {
      final Object? daya = event.snapshot.value;
      setState(() {
        _textdaya = daya.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // bool isRunning = timer == null ? false : timer!.isActive;
    if (arusL > 100 && isRunning == false) {
      setState(() {
        index = 1;
        isRunning = true;
        isDone = false;
      });
      startTimer();
    }

    if (arusL < 101 && isRunning == true) {
      setState(() {
        isDone = true;
        isRunning = false;
      });
      timer?.cancel();
    }
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: size.height / 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Arus Listrik: ',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$_textarus mA',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: size.height / 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Daya Listrik : ',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$_textdaya W',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    (index == 0 && isDone == false)
                        ? 'Mesin Belum Bekerja'
                        : (index == 1 && isDone == false)
                            ? 'Mesin Sedang Bekerja'
                            : 'Mesin Selesai Bekerja',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: size.width / 3.5,
                          height: size.height / 5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              '${duration.inHours}'.padLeft(2, '0'),
                              style: GoogleFonts.poppins(
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Hours',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: size.width / 3.5,
                          height: size.height / 5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              '${duration.inMinutes.remainder(60)}'
                                  .padLeft(2, '0'),
                              style: GoogleFonts.poppins(
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Minutes',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: size.width / 3.5,
                          height: size.height / 5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              '${duration.inSeconds.remainder(60)}'
                                  .padLeft(2, '0'),
                              style: GoogleFonts.poppins(
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Seconds',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            isDone == true
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 0;
                        isRunning = false;
                        isDone = false;
                      });

                      duration = Duration(seconds: 0);
                    },
                    child: Container(
                      width: size.width / 3,
                      height: size.height / 10,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(17)),
                      child: Center(
                        child: Text(
                          'Reset',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : Text('')
          ],
        ),
      ),
    );
  }
}
