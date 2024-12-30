import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_konten.dart';

class DaftarKonten extends StatelessWidget {
  final String lessonId;

  DaftarKonten({super.key, required this.lessonId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengambil data berdasarkan lessonId
  Future<List<Map<String, dynamic>>> fetchKonten() async {
    try {
      var kontenSnapshot = await _firestore
          .collection('konten')
          .where('lessonId', isEqualTo: lessonId) 
          .get();

      // Ubah data konten menjadi List Map
      return kontenSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching konten: $e');
      return [];
    }
  }

  // Fungsi jika nama guru terlalu panjang
  String getShortName(String fullName) {
    List<String> words = fullName.split(' ');
    if (words.length > 3) {
      return '${words.sublist(0, 4).join(' ')}...';
    } else {
      return fullName;
    }
  }

  // Fungsi menghapus konten
  Future<void> deleteContent(BuildContext context, String id) async {
    try {
      await _firestore.collection('konten').doc(id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data konten berhasil dihapus')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting content: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus konten')),
      );
    }
  }

  // Membuat card untuk setiap konten
  Widget buildContentCard(BuildContext scaffoldContext, Map<String, dynamic> content) {
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
                      icon: const Icon(Icons.edit_outlined, size: 22, color: Color(0xFF13ADDE)),
                      onPressed: () {
                        Navigator.push(
                          scaffoldContext,
                          MaterialPageRoute(
                            builder: (context) => EditKonten(
                              kontenId: content['id'],
                              judulSubBab: content['judulSubBab'],
                              pdfUrl: content['pdfUrl'],
                              linkVideo: content['linkVideo'],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: scaffoldContext,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi Hapus'),
                              content: const Text(
                                  'Apakah Anda yakin ingin menghapus data konten ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Batal',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    deleteContent(
                                        scaffoldContext, content['id']);
                                  },
                                  child: const Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
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
            Text(
              content['judulSubBab'] ?? 'Tidak Ada Judul Sub Bab',
              style: GoogleFonts.poppins(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8), 
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  getShortName(content['namaGuru'] ?? 'Tidak Ada Pengajar'),
                  style: GoogleFonts.poppins(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
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
    final scaffoldContext = context;

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
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      'Kelola Konten',
                      style: GoogleFonts.poppins(
                        fontSize: 25,
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
                return const Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
                    )
                  );
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
                    return buildContentCard(scaffoldContext, konten[index]);
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
