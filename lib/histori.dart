import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Histori extends StatefulWidget {
  const Histori({Key? key}) : super(key: key);

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
          return const Scaffold(
            body: Center(
              child: Text('Loading....'),
            ),
          );
        }
        final data = snapshot.requireData;
        return Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView.builder(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Durasi Kerja Mesin : ',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${data.docs[index]['timer']}',
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
              }),
        );
      },
    );
  }
}
