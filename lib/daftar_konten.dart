import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_konten.dart';

class DaftarKonten extends StatelessWidget {
  final String lessonId;

  DaftarKonten({super.key, required this.lessonId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch konten berdasarkan lessonId
  Future<List<Map<String, dynamic>>> fetchKonten() async {
    try {
      var kontenSnapshot = await _firestore
          .collection('konten')
          .where('lessonId',
              isEqualTo: lessonId) // Mengambil data berdasarkan lessonId
          .get();

      // Ubah data konten menjadi List Map
      return kontenSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Tambahkan ID dokumen
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching konten: $e');
      return [];
    }
  }

  // Membuat card untuk setiap konten
  Widget buildContentCard(BuildContext context, Map<String, dynamic> content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color(0xFFFFFD55),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nama Pelajaran
                Expanded(
                  child: Text(
                    content['mataPelajaran'] ?? 'Tidak Ada Pelajaran',
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                // Tombol Edit dan Delete
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          size: 22, color: Color(0xFF13ADDE)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditKonten(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        print('Delete content: ${content['judulSubBab']}');
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              content['kelas'] ?? 'Tidak Ada Kelas',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  content['judulSubBab'] ?? 'Tidak Ada Judul Sub Bab',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                Text(
                  content['namaGuru'] ?? 'Tidak Ada Pengajar',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 25),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Kelola Konten Pelajaran',
                      style: GoogleFonts.poppins(
                        fontSize: 21,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // FutureBuilder untuk mengambil data konten
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchKonten(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.poppins(fontSize: 15, color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      'Tidak ada konten',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }

              var konten = snapshot.data!;
              return Expanded(
                child: ListView.builder(
                  itemCount: konten.length,
                  itemBuilder: (context, index) {
                    return buildContentCard(context, konten[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
