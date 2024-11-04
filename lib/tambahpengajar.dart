import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:microlearning/kelolapengajar.dart'; // Pastikan jalur ini benar

class TambahPengajar extends StatefulWidget {
  const TambahPengajar({super.key});

  @override
  TambahPengajarState createState() => TambahPengajarState();
}

class TambahPengajarState extends State<TambahPengajar> {
  String? selectedTeacher; // Variabel untuk menyimpan nama guru yang dipilih
  String? selectedSubject; // Variabel untuk menyimpan mata pelajaran yang dipilih
  String? selectedKelas; // variabel untuk menyimpan kategori kelas
  final List<String> daftarPelajaran = [
    'Pelajaran 1',
    'Pelajaran 2',
    'Pelajaran 3',
    'Pelajaran 4',
    'Pelajaran 5',
  ];

  final List<String> daftarkelas = [
    'Kelas 10',
    'Kelas 11',
    'Kelas 12',
  ];

  Future<void> simpanData() async {
    if (selectedTeacher != null && selectedSubject != null && selectedKelas != null) {
      try {
        await FirebaseFirestore.instance.collection('pengajar').add({
          'namaGuru': selectedTeacher,
          'mataPelajaran': selectedSubject,
          'kelas': selectedKelas,
        });

        if (!mounted) return; // Periksa apakah widget masih terpasang

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan')),
        );

        // Kembali ke halaman sebelumnya setelah menyimpan data
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KelolaPengajar()),
        ); // Kembali ke halaman KelolaPengajar
      } catch (e) {
        if (!mounted) return; // Periksa apakah widget masih terpasang
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      if (!mounted) return; // Periksa apakah widget masih terpasang
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan lengkapi semua pilihan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFD55), // Warna latar belakang header
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KelolaPengajar()),
            ); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFD55), // Warna latar belakang header
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150),
                bottomRight: Radius.circular(150),
              ),
            ),
            child: Center(
              child: Text(
                'Kelola Pengajar',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'Teacher')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Tidak ada guru ditemukan'));
                }

                // Mengambil field 'name' dari setiap dokumen
                List<String> daftarTeacher = snapshot.data!.docs.map((doc) {
                  return doc['name'] as String;
                }).toList();

                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Pilih Nama Guru',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      value: selectedTeacher,
                      items: daftarTeacher.map((String teacher) {
                        return DropdownMenuItem<String>(
                          value: teacher,
                          child: Text(teacher),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTeacher = newValue;
                        });
                      },
                      hint: const Text('Pilih Guru'),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Pilih Mata Pelajaran',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      value: selectedSubject,
                      items: daftarPelajaran.map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSubject = newValue;
                        });
                      },
                      hint: const Text('Pilih Mata Pelajaran'),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Pilih Kategori Kelas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      value: selectedKelas,
                      items: daftarkelas.map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedKelas = newValue;
                        });
                      },
                      hint: const Text('Pilih Kategori Kelas'),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: simpanData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Simpan'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
