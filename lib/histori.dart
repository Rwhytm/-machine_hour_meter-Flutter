import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Histori extends StatefulWidget {
  double settime;
  Histori({required this.settime, Key? key}) : super(key: key);

  @override
  State<Histori> createState() => _HistoriState();
}

class _HistoriState extends State<Histori> {
  final Stream<QuerySnapshot> timer = FirebaseFirestore.instance
      .collection('timer')
      .orderBy(
        'createdAt',
        descending: true,
      )
      .snapshots();

  double totalHour = 0;
  double totalMinutes = 0;
  double totalSeconds = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: timer,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.blue[500],
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final data = snapshot.requireData;
        for (int i = 0; i < data.size; i++) {
          double jam = totalHour + int.parse(data.docs[i]['hour'].toString());
          double menit =
              totalMinutes + int.parse(data.docs[i]['minutes'].toString());
          double detik =
              totalSeconds + int.parse(data.docs[i]['seconds'].toString());
          totalHour = jam;
          totalMinutes = menit;
          totalSeconds = detik;
        }
        if (totalSeconds > 60) {
          double detik = totalSeconds % 60;
          totalMinutes =
              totalMinutes + ((totalSeconds - detik) / 60).toDouble();
          totalSeconds = detik;
        }
        if (totalMinutes > 60) {
          double menit = totalMinutes % 60;
          totalHour = totalHour + ((totalMinutes - menit) / 60);
          totalMinutes = menit;
        }
        double sisa = widget.settime - totalHour;
        return Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(
            title: const Text('Riwayat Kinerja Mesin'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: data.size != 0
              ? ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: size.width * 0.9,
                          height: size.height * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Durasi Kerja Mesin :  ',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${data.docs[index]['hour']} Jam ${data.docs[index]['minutes']} Menit ${data.docs[index]['seconds']} Detik',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  })
              : Center(
                  child: Text(
                    'Tidak ada Riwayat',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
          bottomNavigationBar: Container(
            color: Colors.blue[800],
            width: 30,
            height: 110,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Total Kinerja Mesin : \n${totalHour.toInt()} Jam ${totalMinutes.toInt()} Menit ${totalSeconds.toInt()} Detik',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Waktu Perawatan Tinggal ${sisa.round()} jam lagi',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
