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
  final CollectionReference kontenCollection =
      FirebaseFirestore.instance.collection('konten');

  final Set<String> displayedClasses =
      <String>{}; // Set untuk menyimpan mata pelajaran unik

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
                      fontSize: 25,
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
              stream: kontenCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
                  )
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Materi tidak ditemukan'));
                }

                final data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final String mataPelajaran =
                        data[index]['mataPelajaran'] ?? '';
                    final String lessonId = data[index]['lessonId'] ?? '';

                    // Cek duplikasi
                    if (mataPelajaran.isEmpty ||
                        displayedClasses.contains(mataPelajaran.toUpperCase())) {
                      return const SizedBox.shrink();
                    }

                    displayedClasses.add(mataPelajaran.toUpperCase()); 

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KelasPage(
                                mataPelajaran: mataPelajaran,
                                idlesson: lessonId,
                              ),
                            ),
                          );
                        },
                        child: _buildMateriBox(mataPelajaran),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  // Widget untuk membuat box mata pelajaran
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
