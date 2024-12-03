import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'kelas_page.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  final CollectionReference pengajarCollection =
      FirebaseFirestore.instance.collection('pengajar');
  
  // Set untuk menyimpan mata pelajaran yang sudah ditampilkan
  Set<String> displayedMapel = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFD55),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150),
                bottomRight: Radius.circular(150),
              ),
            ),
            child: Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Text(
                    'Mata Pelajaran',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          // Ambil dan tampilkan mata pelajaran dari Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: pengajarCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                }

                final data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    // Ambil nama mata pelajaran 
                    String subject = data[index]['mataPelajaran'];

                    // Mengecek supaya tidak ada duplikasi mata pelajaran
                    if (displayedMapel.contains(subject)) {
                      return const SizedBox.shrink(); // Jika sudah ditampilkan, tidak tampilkan lagi
                    }

                    // Tambahkan mata pelajaran ke dalam set agar tidak duplikat
                    displayedMapel.add(subject);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      child: GestureDetector(
                        onTap: () {
                          // Kirim nama mata pelajaran ke halaman kelas
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KelasPage(),
                            ),
                          );
                        },
                        child: _buildMateriBox(subject),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriBox(String subject) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF13ADDE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          subject,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
