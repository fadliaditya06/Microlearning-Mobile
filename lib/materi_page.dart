import 'package:flutter/material.dart';

class MateriPage extends StatelessWidget {
  const MateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi'), // Menambahkan judul untuk AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Mengubah untuk merapat ke atas
            children: [
              const SizedBox(height: 20), // Padding atas
              _buildMateriBox(context, "Matematika"),
              const SizedBox(height: 20), // Jarak antar box
              _buildMateriBox(context, "Biologi"),
              const SizedBox(height: 20), // Jarak antar box
              _buildMateriBox(context, "PKN"),
              const SizedBox(height: 20), // Jarak antar box
              _buildMateriBox(context, "Fisika"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMateriBox(BuildContext context, String subject) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KelasPage(subject: subject),
          ),
        );
      },
      child: Container(
        width: 300, // Lebar box
        padding: const EdgeInsets.all(20), 
        decoration: BoxDecoration(
          color: Colors.blueAccent, 
          borderRadius: BorderRadius.circular(10), 
        ),
        child: Center(
          child: Text(
            subject,
            style: const TextStyle(
              color: Colors.white, // Warna teks
              fontSize: 24, // Ukuran teks
              fontWeight: FontWeight.bold, // Ketebalan teks
            ),
          ),
        ),
      ),
    );
  }
}

class KelasPage extends StatelessWidget {
  final String subject;

  const KelasPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelas $subject'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Mengubah agar rapat ke atas
            children: List.generate(3, (index) {
              int kelasNumber = index + 10; // Kelas 10, 11, 12
              return _buildKelasBox(kelasNumber);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildKelasBox(int kelasNumber) {
    return Container(
      width: 300, // Lebar box
      padding: const EdgeInsets.all(20), 
      margin: const EdgeInsets.symmetric(vertical: 10), 
      decoration: BoxDecoration(
        color: Colors.blueAccent, 
        borderRadius: BorderRadius.circular(10), 
      ),
      child: Center(
        child: Text(
          'Kelas $kelasNumber',
          style: const TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
          ),
        ),
      ),
    );
  }
}
