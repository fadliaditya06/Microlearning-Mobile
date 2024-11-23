import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kelas_page.dart'; 

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
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
                const Spacer(),
                // Memastikan teks berada di tengah
                Padding(
                  padding: const EdgeInsets.only(right: 2.0), 
                  child: Text(
                    'Mata Pelajaran',
                    style: GoogleFonts.poppins(
                      fontSize: 26, 
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KelasPage()),
              );
            },
            child: _buildMateriBox("Matematika"),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KelasPage()),
              );
            },
            child: _buildMateriBox("Biologi"),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KelasPage()),
              );
            },
            child: _buildMateriBox("PKN"),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KelasPage()),
              );
            },
            child: _buildMateriBox("Fisika"),
          ),
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
}
