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
  String? selectedMataPelajaran;
  String? selectedKelas;

  final List<String> mataPelajaranList = [
    'Matematika',
    'Bahasa Indonesia',
    'Ilmu Pengetahuan Alam',
    'Ilmu Pengetahuan Sosial',
  ];

  final List<String> kelasList = [
    'Kelas 10',
    'Kelas 11',
    'Kelas 12',
  ];

  @override
  void initState() {
    super.initState();
    namaGuruController = TextEditingController(text: widget.data['namaGuru']);
    selectedMataPelajaran = mataPelajaranList.contains(widget.data['mataPelajaran'])
        ? widget.data['mataPelajaran']
        : mataPelajaranList.first;
    selectedKelas = kelasList.contains(widget.data['kelas']) ? widget.data['kelas'] : kelasList.first;
  }

  @override
  void dispose() {
    namaGuruController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFD55),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150),
                bottomRight: Radius.circular(150),
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'Edit Pengajar',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: namaGuruController,
              readOnly: true, // Membuat input tidak dapat diedit
              decoration: const InputDecoration(
                labelText: 'Nama Guru',
                border: OutlineInputBorder(), // Tambahkan border
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedMataPelajaran,
              decoration: const InputDecoration(
                labelText: 'Judul Mapel',
                border: OutlineInputBorder(), // Tambahkan border
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
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedKelas,
              decoration: const InputDecoration(
                labelText: 'Kelas',
                border: OutlineInputBorder(), // Tambahkan border
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
            const SizedBox(height: 20),
           
         Center(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
     backgroundColor : Colors.blue, // Mengubah warna tombol menjadi biru
    ),
    onPressed: () async {
      // Menyiapkan data yang akan disimpan
      Map<String, dynamic> dataToUpdate = {
        'mataPelajaran': selectedMataPelajaran,
        'kelas': selectedKelas,
      };
      try {
        // Mengupdate data di Firestore
        await FirebaseFirestore.instance
            .collection('pengajar') 
            .doc(widget.data['id']) 
            .update(dataToUpdate);

        // Tampilkan SnackBar untuk konfirmasi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan!')),
        );

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      } catch (e) {
        // Menangani kesalahan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    },
    child: const Text('Simpan Perubahan'),
  ),
),

          ],
        ),
      ),
    );
  }
}
