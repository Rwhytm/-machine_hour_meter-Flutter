// ignore_for_file: must_call_super, prefer_const_constructors

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_hour_meter/common/services.dart';
import 'package:machine_hour_meter/histori.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  //inisialisasi variabel
  Duration duration = const Duration();
  int index = 0;
  Timer? timer;
  bool isRunning = false;
  bool isDone = false;
  String _textarus = '';
  int arusL = 0;
  String _textdaya = '';
  final referencesData = FirebaseDatabase.instance.ref();

  //inisialisasi data dari database
  @override
  void initState() {
    _activeListener();
  }

  //fungsi manambah satu detik untuk timer
  void addTime() {
    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  //memulai timer
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), ((_) => addTime()));
  }

//fungsi untuk memberhentikan waktu
  void stopTimer({bool resets = true}) {}

//memanggil data arus dan daya dari firebase
  void _activeListener() {
    //memanggil data arus
    referencesData.child('arus listrik').onValue.listen((event) {
      final Object? arus = event.snapshot.value;
      setState(() {
        _textarus = arus.toString();
        arusL = int.parse(arus.toString());
      });
    });

    // memanggil data daya
    referencesData.child('daya listrik').onValue.listen((event) {
      final Object? daya = event.snapshot.value;
      setState(() {
        _textdaya = daya.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //mulai timer ketika arus > 100
    if (arusL > 100 && isRunning == false) {
      setState(() {
        index = 1;
        isRunning = true;
        isDone = false;
      });
      startTimer();
      AuthServices.pauseTime().then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Timer Berjalan'),
          ),
        ),
      );
    }

    //berhenti ketika arus lebih kecil dari 101
    if (arusL < 101 && isRunning == true) {
      setState(() {
        isDone = true;
        isRunning = false;
      });
      timer?.cancel();
      AuthServices.pauseTime().then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Timer Berhenti'),
          ),
        ),
      );
    }
    Size size = MediaQuery.of(context).size;

    //android
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.list,
              size: 35,
            ),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Histori(),
                ),
              );
              // await AuthServices.timerSave(
              //     "${duration.inHours} : ${duration.inMinutes} : ${duration.inSeconds}");
            },
          ),
        ],
      ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    onTap: () async {
                      await AuthServices.timerSave(
                              duration.inHours,
                              duration.inMinutes.remainder(60),
                              duration.inSeconds.remainder(60))
                          .then((value) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Derasi Mesin ${duration.inHours} Jam : ${duration.inMinutes.remainder(60)} Menit : ${duration.inSeconds.remainder(60)} Detik, Berhasil disimpan'),
                                ),
                              ));
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
