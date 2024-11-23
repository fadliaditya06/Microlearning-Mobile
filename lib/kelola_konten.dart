import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:microlearning/edit_konten.dart';
import 'package:microlearning/tambah_konten.dart';

class Pelajaran {
  final String namaPelajaran;
  final String kelas;
  final String pengajar;
  final List<String> materi;

  Pelajaran({
    required this.namaPelajaran,
    required this.kelas,
    required this.pengajar,
    required this.materi,
  });
}

class KelolaKontenPage extends StatefulWidget {
  const KelolaKontenPage({super.key});

  @override
  KelolaKontenPageState createState() => KelolaKontenPageState();
}

class KelolaKontenPageState extends State<KelolaKontenPage> {
  final List<Pelajaran> daftarPelajaran = [
    Pelajaran(
      namaPelajaran: 'Biologi',
      kelas: 'Kelas 10',
      pengajar: 'Stupen S.Pd',
      materi: ['Genetika', 'Sel'],
    ),
    Pelajaran(
      namaPelajaran: 'Fisika',
      kelas: 'Kelas 10',
      pengajar: 'Stupen S.Pd',
      materi: ['Mekanika', 'Termodinamika'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header setengah lingkaran
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
                'Kelola Konten Pelajaran',
                style: GoogleFonts.poppins(
                  fontSize: 21,
                  color: Colors.black,
                ),
                overflow:
                    TextOverflow.ellipsis, 
                    
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: daftarPelajaran.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPelajaranPage(
                            pelajaran: daftarPelajaran[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        color: const Color(0xFFFFFD55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(
                              15), 
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      daftarPelajaran[index].namaPelajaran,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const TambahKonten(),
                                        ),
                                      );
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              Text(
                                daftarPelajaran[index].kelas,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  daftarPelajaran[index].pengajar,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

class DetailPelajaranPage extends StatelessWidget {
  final Pelajaran pelajaran;

  const DetailPelajaranPage({super.key, required this.pelajaran});

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
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: pelajaran.materi.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      color: const Color(0xFFFFFD55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    pelajaran.materi[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          size: 22, color: Color(0xFF13ADDE)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditKonten(),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          size: 22, color: Colors.red),
                                      onPressed: () {
                                        print(
                                            'Hapus materi ${pelajaran.materi[index]}');
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              pelajaran.kelas,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                pelajaran.pengajar,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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