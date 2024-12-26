import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TambahKonten extends StatefulWidget {
  final String lessonId;

  const TambahKonten({super.key, required this.lessonId});

  @override
  TambahKontenState createState() => TambahKontenState();
}

class TambahKontenState extends State<TambahKonten> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController subBabController = TextEditingController();
  final TextEditingController linkvidioController = TextEditingController();

  String? pdfFileName;
  Uint8List? pdfBytes;
  String? videoUrl;
  bool _isSaving = false;

  // Data tambahan dari Firestore
  String? namaGuru;
  String? kelas;
  String? mataPelajaran;

  @override
  void initState() {
    super.initState();
    _fetchLessonDetails();
  }

  @override
  void dispose() {
    subBabController.dispose();
    linkvidioController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil informasi lesson detail dari Firestore
  Future<void> _fetchLessonDetails() async {
    try {
      DocumentSnapshot lessonSnapshot = await FirebaseFirestore.instance
          .collection('pengajar')
          .doc(widget.lessonId)
          .get();

      if (lessonSnapshot.exists) {
        setState(() {
          namaGuru = lessonSnapshot['namaGuru'];
          kelas = lessonSnapshot['kelas'];
          mataPelajaran = lessonSnapshot['mataPelajaran'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data lesson: $e')),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Tambah Konten',
                      style: GoogleFonts.poppins(fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Form Input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Judul Sub Bab
                    Text(
                      'Judul Sub Bab',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: subBabController,
                      cursorColor: const Color(0xFF13ADDE),
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
                        labelText: 'Input Judul Sub Bab',
                        labelStyle: GoogleFonts.poppins(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silahkan masukkan judul sub bab';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    // Materi
                    Text(
                      'Materi',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF13ADDE),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: _pickPdfFile,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.upload, color: Colors.black, size: 25),
                                const SizedBox(width: 10),
                                Text(
                                  'Input Materi PDF',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          pdfFileName ?? 'Tidak ada file PDF',
                          style: GoogleFonts.poppins(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Link YouTube Video
                    Text(
                      'Video',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: linkvidioController,
                      cursorColor: const Color(0xFF13ADDE),
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
                        labelText: 'Input Link Video',
                        labelStyle: GoogleFonts.poppins(color: Colors.black),
                      ),
                      validator: (value) {
                        if ((value == null || value.isEmpty) &&
                            pdfBytes == null) {
                          return 'Silahkan masukkan link video YouTube';
                        }
                        if (value != null && value.isNotEmpty) {
                          final youtubeRegex = RegExp(
                            r'^(https?\:\/\/)?(www\.youtube\.com|youtu\.be)\/.+$',
                            caseSensitive: false,
                          );
                          if (!youtubeRegex.hasMatch(value)) {
                            return 'Link video Youtube tidak valid';
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        final youtubeRegex = RegExp(
                          r'^(https?\:\/\/)?(www\.youtube\.com|youtu\.be)\/.+$',
                          caseSensitive: false,
                        );
                        if (youtubeRegex.hasMatch(value)) {
                          videoUrl = value; 
                        } else {
                          videoUrl = null; 
                        }
                      },
                    ),
                    const SizedBox(height: 50),
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
                        onPressed: _isSaving
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  if (pdfBytes == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Silahkan input file PDF terlebih dahulu'),
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    _isSaving = true;
                                  });
                                  await _saveContent();
                                  setState(() {
                                    _isSaving = false;
                                  });
                                }
                              },
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                'Simpan',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memilih file PDF
  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Hanya file dengan format PDF
      withData: true,
    );

    if (result != null) {
      final platformFile = result.files.single;
      if (platformFile.extension != 'pdf') {
        // Validasi file jika bukan format PDF
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File yang dipilih harus PDF')),
        );
        return;
      }

      setState(() {
        pdfFileName = platformFile.name;
        pdfBytes = platformFile.bytes;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada file yang dipilih')),
      );
    }
  }

  // Fungsi untuk menyimpan data ke Firestore
  Future<void> _saveContent() async {
    try {
      // Pastikan pengguna terautentikasi
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengguna tidak terautentikasi')),
        );
        return;
      }

      String? pdfUrl;

      // Upload file PDF ke Firebase Storage
      if (pdfBytes != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('konten/${user.uid}/${widget.lessonId}_${pdfFileName!}');
        final uploadTask = await storageRef.putData(pdfBytes!);
        pdfUrl = await uploadTask.ref.getDownloadURL();
      }

      // Konversi mataPelajaran menjadi huruf besar 
      final mataPelajaranUpperCase = mataPelajaran?.toUpperCase();

      // Simpan data ke Firestore dengan userId dan data tambahan
      await FirebaseFirestore.instance.collection('konten').add({
        'userId': user.uid, // Simpan userId
        'lessonId': widget.lessonId,
        'judulSubBab': subBabController.text,
        'linkVideo': videoUrl,
        'pdfFileName': pdfFileName,
        'pdfUrl': pdfUrl,
        'namaGuru': namaGuru, // Simpan nama guru
        'kelas': kelas, // Simpan kelas
        'mataPelajaran': mataPelajaranUpperCase, // Simpan mata pelajaran dalam huruf besar
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }
}
