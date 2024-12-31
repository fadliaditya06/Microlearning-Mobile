import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPengajar extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditPengajar({required this.data, super.key});

  @override
  EditPengajarState createState() => EditPengajarState();
}

class EditPengajarState extends State<EditPengajar> {
  late TextEditingController namaGuruController;
  bool _isLoading = false;
  String? selectedMataPelajaran;
  String? selectedKelas;

  // Daftar Mata Pelajaran
  final List<String> mataPelajaranList = [
    'MATEMATIKA',
    'BAHASA INDONESIA',
    'BIOLOGI',
    'FISIKA',
    'PKN',
    'PAI',
    'ENGLISH',
    'ARABIC',
    'INFORMATIKA',
    'KIMIA',
    'GEOGRAFI',
    'EKONOMI',
    'SOSIOLOGI',
    'SEJARAH',
    'ART & CRAFT',
  ];

  // Daftar Kategori Kelas
  final List<String> kelasList = [
    'Kelas 10',
    'Kelas 11',
    'Kelas 12',
  ];

  // Menginisialisasi nilai awal untuk nama guru, mata pelajaran dan kelas
  @override
  void initState() {
    super.initState();
    namaGuruController = TextEditingController(text: widget.data['namaGuru']);
    selectedMataPelajaran =
        mataPelajaranList.contains(widget.data['mataPelajaran'])
            ? widget.data['mataPelajaran']
            : mataPelajaranList.first;
    selectedKelas = kelasList.contains(widget.data['kelas'])
        ? widget.data['kelas']
        : kelasList.first;
  }

  @override
  void dispose() {
    namaGuruController.dispose();
    super.dispose();
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 110.0),
                  child: Text(
                    'Edit Pengajar',
                    style: GoogleFonts.poppins(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: ListView(
                  children: [
                    // Input Nama Pengajar
                    Text(
                      'Nama Pengajar',
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: namaGuruController,
                      readOnly: true,
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
                    ),
                    const SizedBox(height: 30),

                    // Dropdown Mata Pelajaran
                    Text(
                      'Judul Mata Pelajaran',
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: selectedMataPelajaran,
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
                      items: mataPelajaranList.map((mataPelajaran) {
                        return DropdownMenuItem(
                          value: mataPelajaran,
                          child: Text(mataPelajaran),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMataPelajaran = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),

                    // Dropdown Kelas
                    Text(
                      'Kelas',
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: selectedKelas,
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
                      items: kelasList.map((kelas) {
                        return DropdownMenuItem(
                          value: kelas,
                          child: Text(kelas),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedKelas = value;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13ADDE),
                          disabledBackgroundColor: const Color(0xFF13ADDE),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                Map<String, dynamic> dataToUpdate = {
                                  'mataPelajaran': selectedMataPelajaran,
                                  'kelas': selectedKelas,
                                };
                                try {
                                  // Memperbarui data pengajar di Firestore
                                  await FirebaseFirestore.instance
                                      .collection('pengajar')
                                      .doc(widget.data['id'])
                                      .update(dataToUpdate);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Data berhasil diperbarui')),
                                  );

                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Gagal menyimpan data: $e')),
                                  );
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Simpan Perubahan",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
