import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mengubah indeks yang dipilih
    });
  }

  void _onKelasTapped(String kelas) {
    setState(() {
      _selectedIndex = 2; // Tampilkan konten list konten
    });
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
            child: Center(
              child: Text(
                _selectedIndex == 0 ? 'Mata Pelajaran' : 
                _selectedIndex == 1 ? 'Kategori Kelas' : 
                'Konten Pelajaran',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 0), // Menghapus jarak di bawah setengah lingkaran
          Expanded(
            child: _selectedIndex == 0 
                ? _buildMateriContent() 
                : _selectedIndex == 1 
                    ? _buildKelasContent() 
                    : _buildListKontenContent(),
          ),
        ],
      ),
    );
  }
  // Materi
  Widget _buildMateriContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20), 
          GestureDetector(
            onTap: () {
              _onItemTapped(1); // Navigasi ke Kelas
            },
            child: _buildMateriBox("Matematika"),
          ),
          const SizedBox(height: 20), 
          GestureDetector(
            onTap: () {
              _onItemTapped(1); 
            },
            child: _buildMateriBox("Biologi"),
          ),
          const SizedBox(height: 20), 
          GestureDetector(
            onTap: () {
              _onItemTapped(1); 
            },
            child: _buildMateriBox("PKN"),
          ),
          const SizedBox(height: 20), 
          GestureDetector(
            onTap: () {
              _onItemTapped(1); 
            },
            child: _buildMateriBox("Fisika"),
          ),
        ],
      ),
    );
  }
  // Kategori Kelas
  Widget _buildKelasContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20), 
          GestureDetector(
            onTap: () => _onKelasTapped("Kelas 10"),
            child: _buildKelasBox("Kelas 10"),
          ),
          const SizedBox(height: 20), // Jarak antar box
          GestureDetector(
            onTap: () => _onKelasTapped("Kelas 11"),
            child: _buildKelasBox("Kelas 11"),
          ),
          const SizedBox(height: 20), // Jarak antar box
          GestureDetector(
            onTap: () => _onKelasTapped("Kelas 12"),
            child: _buildKelasBox("Kelas 12"),
          ),
        ],
      ),
    );
  }
  // List Konten
  Widget _buildListKontenContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Bar
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
              child: SizedBox(
                width: 118,
                height: 27,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10), // Padding di dalam
                    suffixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), 
                      borderSide: const BorderSide(color: Color(0xFF13ADDE), width: 1), 
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF13ADDE), width: 1,), 
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Padding atas
          _buildListKontenBox("Genetika"),
          const SizedBox(height: 20), 
          _buildListKontenBox("Sel"),
          const SizedBox(height: 20), 
          _buildListKontenBox("Mutasi"),
          const SizedBox(height: 20), 
          _buildListKontenBox("Virus"),
        ],
      ),
    );
  }

  Widget _buildMateriBox(String subject) {
    return Container(
      width: 300, // Lebar box
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:const Color(0xFF13ADDE), 
        borderRadius: BorderRadius.circular(30), 
      ),
      child: Center(
        child: Text(
          subject,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildKelasBox(String kelas) {
    return Container(
      width: 300, // Lebar box
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
    );
  }

  Widget _buildListKontenBox(String konten) {
    return Container(
      width: 300, // Lebar box
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF13ADDE), 
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          konten,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
