import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'konten.dart'; 

class ListKontenPage extends StatelessWidget {
  const ListKontenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
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
                    'Konten Pelajaran',
                    style: GoogleFonts.poppins(fontSize: 25, color: Colors.black), 
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildListKontenBox(context, "Genetika"),
          const SizedBox(height: 20),
          _buildListKontenBox(context, "Sel"),
          const SizedBox(height: 20),
          _buildListKontenBox(context, "Mutasi"),
          const SizedBox(height: 20),
          _buildListKontenBox(context, "Virus"),
        ],
      ),
    );
  }

  Widget _buildListKontenBox(BuildContext context, String konten) {
    return GestureDetector(
      onTap: () {
        if (konten == "Genetika") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContentPage()),
          );
        }
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
            konten,
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
