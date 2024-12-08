import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahPengajar extends StatefulWidget {
  const TambahPengajar({super.key});

  @override
  TambahPengajarState createState() => TambahPengajarState();
}

class TambahPengajarState extends State<TambahPengajar> {
  String? selectedTeacher;
  String? selectedSubject;
  String? selectedKelas;

  final List<String> daftarPelajaran = [
    'Matematika',
    'Bahasa Indonesia',
    'Biologi',
    'Fisika',
  ];

  final List<String> daftarKelas = [
    'Kelas 10',
    'Kelas 11',
    'Kelas 12',
  ];

  Future<void> simpanData() async {
    if (selectedTeacher != null &&
        selectedSubject != null &&
        selectedKelas != null) {
      try {
        await FirebaseFirestore.instance.collection('pengajar').add({
          'namaGuru': selectedTeacher,
          'mataPelajaran': selectedSubject,
          'kelas': selectedKelas,
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan')),
        );

        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan lengkapi semua pilihan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 25),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Tambah Pengajar',
                      style: GoogleFonts.poppins(fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                    return const Center(
                        child: Text('Tidak ada guru ditemukan'));
                  }

                  List<String> daftarTeacher = snapshot.data!.docs.map((doc) {
                    return doc['name'] as String;
                  }).toList();

                  return ListView(
                    children: [
                      // Input Nama Pengajar
                      Text(
                        'Nama Pengajar',
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1),
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
                        hint: const Text(
                          'Pilih Guru',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Input Mata Pelajaran
                      Text(
                        'Mata Pelajaran',
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1),
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
                        hint: const Text(
                          'Pilih Mata Pelajaran',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Input Kelas
                      Text(
                        'Kategori Kelas',
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1),
                          ),
                        ),
                        value: selectedKelas,
                        items: daftarKelas.map((String kelas) {
                          return DropdownMenuItem<String>(
                            value: kelas,
                            child: Text(kelas),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedKelas = newValue;
                          });
                        },
                        hint: const Text(
                          'Pilih Kategori Kelas',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: simpanData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Atur radius sudut di sini
                            ),
                          ),
                          child: Text(
                            "Simpan",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
