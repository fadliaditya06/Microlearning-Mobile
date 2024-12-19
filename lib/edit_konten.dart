import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class EditKonten extends StatefulWidget {
  final String kontenId;
  final String judulSubBab;
  final String pdfUrl;
  final String linkVideo;

  const EditKonten({
    super.key,
    required this.kontenId,
    required this.judulSubBab,
    required this.pdfUrl,
    required this.linkVideo,
  });

  @override
  EditKontenState createState() => EditKontenState();
}

class EditKontenState extends State<EditKonten> {
  final _formKey = GlobalKey<FormState>(); 
  bool showProgress = false;
  late TextEditingController subBabController;
  late TextEditingController linkvidioController;
  String? pdfUrl;
  String? videoUrl; 

  @override
  void initState() {
    super.initState();
    subBabController = TextEditingController();
    linkvidioController = TextEditingController();
    _loadKontenData();
  }

  // Fungsi untuk mengambil data konten dari Firestore
  Future<void> _loadKontenData() async {
    try {
      DocumentSnapshot kontenSnapshot = await FirebaseFirestore.instance
          .collection('konten') 
          .doc(widget.kontenId)
          .get();

      if (kontenSnapshot.exists) {
        var kontenData = kontenSnapshot.data() as Map<String, dynamic>;
        setState(() {
          subBabController.text = kontenData['judulSubBab'] ?? '';
          linkvidioController.text = kontenData['linkVideo'] ?? '';
          pdfUrl = kontenData['pdfUrl'];
          videoUrl = kontenData['linkVideo']; 
        });
      }
    } catch (e) {
      print("Error loading konten: $e");
    }
  }

  // Fungsi untuk memperbarui data konten ke Firestore
  Future<void> _updateKonten() async {
    setState(() {
      showProgress = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('konten')
          .doc(widget.kontenId)
          .update({
        'judulSubBab': subBabController.text,
        'linkVideo': videoUrl,
        'pdfUrl': pdfUrl,
      });

      _loadKontenData();

      setState(() {
        showProgress = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konten berhasil diperbarui')),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        showProgress = false;
      });

      // Tampilkan pesan kesalahan jika ada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  // Fungsi untuk mengunggah file PDF
  Future<void> _pickPDFfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf'], withData: true);
    if (result != null) {
      var file = result.files.single;

      // Unggah file PDF ke Firebase Storage
      try {
        String pdfUrl = await FirebaseStorage.instance
            .ref()
            .child('pdfs/${file.name}')
            .putData(file.bytes!)
            .then((snapshot) => snapshot.ref.getDownloadURL());

        setState(() {
          this.pdfUrl = pdfUrl; // Simpan URL file PDF yang telah diupload
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File PDF berhasil diunggah')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat mengunggah PDF')),
        );
      }
    }
  }

  @override
  void dispose() {
    subBabController.dispose();
    linkvidioController.dispose();
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
                    padding: const EdgeInsets.symmetric(horizontal: 55),
                    child: Text(
                      'Edit Konten',
                      style: GoogleFonts.poppins(fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Konten Form
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Edit Judul Sub Bab
                    Text(
                      'Judul Sub Bab',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: subBabController,
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
                        labelText: 'Ubah Judul Sub Bab',
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
                    // Edit Materi PDF
                    Text(
                      'Materi',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w500),
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
                            onPressed: _pickPDFfile, 
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.upload,
                                    color: Colors.black, size: 25),
                                const SizedBox(width: 10),
                                Text(
                                  'Ubah Materi PDF',
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
                          pdfUrl ?? 'Tidak ada file PDF',
                          style: GoogleFonts.poppins(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Edit Link Video Youtube
                    Text(
                      'Video',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: linkvidioController,
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
                        labelText: 'Ubah Link Video',
                        labelStyle: GoogleFonts.poppins(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silahkan masukkan link video';
                        }
                        final youtubeRegex = RegExp(
                          r'^(https?\:\/\/)?(www\.youtube\.com|youtu\.be)\/.+$',
                          caseSensitive: false,
                        );
                        if (!youtubeRegex.hasMatch(value)) {
                          return 'Link video YouTube tidak valid';
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
                    // Tombol untuk menyimpan
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13ADDE),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              showProgress = true;
                            });
                            await _updateKonten();
                            setState(() {
                              showProgress = false;
                            });
                          } else {}
                        },
                        child: showProgress
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Simpan Perubahan",
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
}
