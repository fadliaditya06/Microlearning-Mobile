import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_page.dart';

class KelolaPengguna extends StatefulWidget {
  const KelolaPengguna({super.key});

  @override
  State<KelolaPengguna> createState() => _KelolaPenggunaState();
}

class _KelolaPenggunaState extends State<KelolaPengguna> {
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
            child: Center(
              child: Text(
                'Kelola Pengguna',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Menambahkan jarak antar elemen
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0), // Padding kiri
              child: Text(
                "Daftar Pengguna",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15), // Jarak sebelum tombol
          // Tombol Guru, Siswa, dan Tambah
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Guru dan Siswa 
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Aksi tombol Guru
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
                    const SizedBox(width: 10), // Jarak antar tombol
                    ElevatedButton(
                      onPressed: () {
                        // Aksi tombol Siswa
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
                // Tombol Tambah di sebelah kanan
                ElevatedButton.icon(
                  onPressed: () {
                    // Redirect ke halaman siswa tanpa autentikasi
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.black, size: 17,),
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
          const SizedBox(height: 15), // Jarak sebelum tabel
          // Scroll ke samping
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Scroll secara horizontal
              child: Padding(
                padding: const EdgeInsets.all(16.0), 
                child: DataTable(
                  // Background untuk header kolom
                  headingRowColor: WidgetStateProperty.all(Colors.blue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'No',
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Warna teks
                          fontWeight: FontWeight.bold, // Teks tebal
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Peran',
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Warna teks
                          fontWeight: FontWeight.bold, // Teks tebal
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Email',
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Warna teks
                          fontWeight: FontWeight.bold, // Teks tebal
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Nama',
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Warna teks
                          fontWeight: FontWeight.bold, // Teks tebal
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'NISN/NIP',
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Warna teks
                          fontWeight: FontWeight.bold, // Teks tebal
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Password',
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Warna teks
                          fontWeight: FontWeight.bold, // Teks tebal
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Aksi',
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Warna teks
                          fontWeight: FontWeight.bold, // Teks tebal
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Center(
                        child: Text(
                          '1',
                          style: GoogleFonts.poppins(), // Menerapkan font Poppins
                        ),
                      )),
                      DataCell(Center(
                        child: Text(
                          'Siswa',
                          style: GoogleFonts.poppins(), // Menerapkan font Poppins
                        ),
                      )),
                      DataCell(Center(
                        child: Text(
                          'siswa@123',
                          style: GoogleFonts.poppins(), // Menerapkan font Poppins
                        ),
                      )),
                      DataCell(Center(
                        child: Text(
                          'Stepen',
                          style: GoogleFonts.poppins(), // Menerapkan font Poppins
                        ),
                      )),
                      DataCell(Center(
                        child: Text(
                          '2324',
                          style: GoogleFonts.poppins(), // Menerapkan font Poppins
                        ),
                      )),
                      DataCell(Center(
                        child: Text(
                          '123456',
                          style: GoogleFonts.poppins(), // Menerapkan font Poppins
                        ),
                      )),
                      DataCell(
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Aksi saat ikon delete diklik
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
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
