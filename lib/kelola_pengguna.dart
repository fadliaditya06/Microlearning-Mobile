import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:microlearning/register_page.dart';

class KelolaPengguna extends StatefulWidget {
  const KelolaPengguna({super.key});

  @override
  KelolaPenggunaState createState() => KelolaPenggunaState();
}

class KelolaPenggunaState extends State<KelolaPengguna> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      String? _selectedRole;


  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content:
              const Text('Apakah Anda yakin ingin menghapus data pengguna ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteUsers(id);
                Navigator.of(context).pop();
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
  }

  Future<void> _deleteUsers(String id) async {
    try {
      await usersCollection.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pengguna berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus data user')),
      );
    }
  }

  String peranIndo(String? role) {
    switch (role) {
      case 'Student':
        return 'Siswa';
      case 'Teacher':
        return 'Guru';
      case 'Admin':
        return 'Admin';
      default:
        return 'Tidak ada';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                  'Kelola Pengguna',
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
                  "Daftar Pengguna",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Tombol Filter dan Tambah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedRole = 'Teacher';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Guru',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedRole = 'Student';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Siswa',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
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

            // Menampilkan data pengguna berdasarkan filter peran pengguna
            StreamBuilder<QuerySnapshot>(
              stream: (_selectedRole != null)
                  ? usersCollection
                      .where('role', isEqualTo: _selectedRole)
                      .orderBy('name', descending: false)
                      .snapshots()
                  : usersCollection.orderBy('name', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Terjadi kesalahan"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Tidak ada data pengguna"));
                }

                final data = snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                            'Peran',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Email',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nama',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'NISN/NIP',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Password',
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
                      rows: data.map((doc) {
                        final docData = doc.data() as Map<String, dynamic>;
                        final nipNisn = (docData['role'] == 'Teacher' ||
                                docData['role'] == 'Admin')
                            ? (docData.containsKey('nip') &&
                                    docData['nip'] != null
                                ? docData['nip']
                                : 'Tidak ada')
                            : (docData.containsKey('nisn') &&
                                    docData['nisn'] != null
                                ? docData['nisn']
                                : 'Tidak ada');

                        return DataRow(cells: [
                          DataCell(Text(
                            (data.indexOf(doc) + 1).toString(),
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Text(
                            peranIndo (docData['role']),
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Text(
                            docData['email'] ?? 'Tidak ada',
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Text(
                            docData['name'] ?? 'Tidak ada',
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Text(
                            nipNisn,
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Text(
                            docData['password'] ?? 'Tidak ada',
                            style: GoogleFonts.poppins(),
                          )),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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
