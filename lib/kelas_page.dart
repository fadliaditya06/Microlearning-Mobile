import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'list_konten.dart'; 

class KelasPage extends StatelessWidget {
  const KelasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Header setengah lingkaran
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFD55), // Warna oranye
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
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 70.0),
                  child: Text(
                    'Kategori Kelas',
                    style: GoogleFonts.poppins(fontSize: 25, color: Colors.black), // Mengubah warna teks menjadi putih
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildKelasBox(context, "Kelas 10"),
          const SizedBox(height: 20),
          _buildKelasBox(context, "Kelas 11"),
          const SizedBox(height: 20),
          _buildKelasBox(context, "Kelas 12"),
        ],
      ),
    );
  }

  Widget _buildKelasBox(BuildContext context, String kelas) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ListKontenPage()),
        );
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF13ADDE),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            kelas,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
