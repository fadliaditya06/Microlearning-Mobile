import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_pengajar.dart';
import 'tambah_pengajar.dart';

class KelolaPengajar extends StatefulWidget {
  const KelolaPengajar({super.key});

  @override
  State<KelolaPengajar> createState() => KelolaPengajarState();
}

class KelolaPengajarState extends State<KelolaPengajar> {
  final CollectionReference pengajarCollection =
      FirebaseFirestore.instance.collection('pengajar');

  // Fungsi untuk menampilkan modal konfirmasi
  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus data pengajar ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deletePengajar(id);
                Navigator.of(context).pop(); // Tutup dialog setelah menghapus
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus data pengajar
  Future<void> _deletePengajar(String id) async {
    try {
      await pengajarCollection.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pengajar berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus data pengajar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Header Setengah Lingkaran
            Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFD55),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                  bottomRight: Radius.circular(150),
                ),
              ),
              child: Center(
                child: Text(
                  'Kelola Pengajar',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Daftar Pengajar",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Tombol Tambah di sebelah kanan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TambahPengajar(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.black, size: 17),
                    label: Text(
                      'Tambah',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Pengambilan data pengajar
            StreamBuilder<QuerySnapshot>(
              stream: pengajarCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Terjadi kesalahan"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Tidak ada data pengajar"));
                }

                final data = snapshot.data!.docs;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.blue),
                      columns: [
                        DataColumn(
                          label: Text(
                            'No',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nama Guru',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Judul Mapel',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Kelas',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Aksi',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: data.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        var doc = entry.value;
                        var namaGuru = doc['namaGuru'];
                        var mataPelajaran = doc['mataPelajaran'];
                        var kelas = doc['kelas'];

                        return DataRow(cells: [
                          DataCell(Text(
                            index.toString(),
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Text(
                            namaGuru,
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Text(
                            mataPelajaran,
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Text(
                            kelas,
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  var dataPengajar = {
                                    'id': doc.id,
                                    'namaGuru': doc['namaGuru'],
                                    'mataPelajaran': doc['mataPelajaran'],
                                    'kelas': doc['kelas'],
                                  };
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPengajar(data: dataPengajar),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(doc.id);
                                },
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
