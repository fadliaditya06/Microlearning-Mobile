import 'package:flutter/material.dart';

class MateriPage extends StatelessWidget {
  const MateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Padding atas
              _buildMateriBox(context, "Mtk"),
              const SizedBox(height: 20), // Jarak antar box
              _buildMateriBox(context, "Biologi"),
              const SizedBox(height: 20), // Jarak antar box
              _buildMateriBox(context, "PKn"),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(10, (index) {
              int kelasNumber = index + 1; 
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
