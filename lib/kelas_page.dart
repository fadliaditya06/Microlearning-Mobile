import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'list_konten.dart'; 

class KelasPage extends StatefulWidget {
  const KelasPage({super.key});

  @override
  State<KelasPage> createState() => KelasPageState();
}

class KelasPageState extends State<KelasPage> {
  final CollectionReference pengajarCollection =
      FirebaseFirestore.instance.collection('pengajar');

  // Menyimpan kelas yang sudah ditampilkan
  Set<String> displayedClasses = {};

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
                    style: GoogleFonts.poppins(fontSize: 25, color: Colors.black), // Mengubah warna teks menjadi hitam
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          // Ambil dan tampilkan mata pelajaran dari Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: pengajarCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                final data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    // Ambil nama mata pelajaran dari field kelas
                    String subject = data[index]['kelas'];

                    // Mengecek supaya tidak ada duplikasi kelas
                    if (displayedClasses.contains(subject)) {
                      return const SizedBox.shrink(); 
                    }

                    // Tambahkan kelas ke dalam set agar tidak duplikat
                    displayedClasses.add(subject);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ListKontenPage(),
                            ),
                          );
                        },
                        child: _buildKelasBox(subject),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
}
