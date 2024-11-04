import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  int _selectedIndex = 0;
  String? userKelas; // Menyimpan kelas dari data pengguna

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Memanggil fungsi untuk mengambil data pengguna
  }

  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser; // Ambil pengguna yang sedang login
    if (user != null) {
      // Ambil data pengguna dari Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userKelas = userDoc['kelas']; // Ambil data kelas dari dokumen pengguna
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mengubah indeks yang dipilih
    });
  }

  void _onKelasTapped(String kelas) {
    // Cek jika kelas yang diakses sama dengan kelas pengguna
    if (kelas == userKelas) {
      setState(() {
        _selectedIndex = 2; // Tampilkan konten list konten
      });
    } else {
      // Tampilkan pesan jika siswa tidak memiliki akses
      _showAccessDeniedDialog(kelas);
    }
  }

  void _showAccessDeniedDialog(String kelas) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Akses Ditolak"),
          content: Text("Anda tidak memiliki akses ke konten $kelas."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Header setengah lingkaran warna kuning
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 253, 240, 69),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150),
                bottomRight: Radius.circular(150),
              ),
            ),
            child: Center(
              child: Text(
                _selectedIndex == 0
                    ? 'Mata Pelajaran'
                    : _selectedIndex == 1
                        ? 'Kategori Kelas'
                        : 'Konten Pelajaran',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
              _onItemTapped(1);
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
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _onKelasTapped("Kelas 11"),
            child: _buildKelasBox("Kelas 11"),
          ),
          const SizedBox(height: 20),
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
          // Tampilkan konten sesuai dengan kelas pengguna
          if (userKelas == "Kelas 10") ...[
            _buildListKontenBox("Materi Kelas 10"),
            // Tambahkan konten lain untuk kelas 10 jika perlu
          ] else if (userKelas == "Kelas 11") ...[
            _buildListKontenBox("Materi Kelas 11"),
            // Tambahkan konten lain untuk kelas 11 jika perlu
          ] else if (userKelas == "Kelas 12") ...[
            _buildListKontenBox("Materi Kelas 12"),
            // Tambahkan konten lain untuk kelas 12 jika perlu
          ],
        ],
      ),
    );
  }

  Widget _buildMateriBox(String subject) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF13ADDE),
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
    );
  }

  Widget _buildListKontenBox(String konten) {
    return Container(
      width: 300,
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
