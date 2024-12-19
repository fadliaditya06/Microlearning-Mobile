import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tambah_konten.dart';
import 'daftar_konten.dart';

class KelolaKontenPage extends StatefulWidget {
  const KelolaKontenPage({super.key});

  @override
  KelolaKontenPageState createState() => KelolaKontenPageState();
}

class KelolaKontenPageState extends State<KelolaKontenPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Ambil data dari Firestore berdasarkan UID guru
  Future<List<Map<String, dynamic>>> fetchLessons() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw 'User is not logged in';
      }

      String uid = user.uid;

      QuerySnapshot snapshot = await _firestore
          .collection('pengajar')
          .where('uidGuru', isEqualTo: uid) // Filter berdasarkan UID Guru
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error fetching lessons: $e');
      return [];
    }
  }

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
            child: Center(
              child: Text(
                'Kelola Konten',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // FutureBuilder untuk data
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchLessons(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue)));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style:
                          GoogleFonts.poppins(fontSize: 15, color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 120),
                    child: Center(
                      child: Text('Tidak ada data.',
                          style: TextStyle(fontSize: 17)),
                    ),
                  );
                }

                List<Map<String, dynamic>> lessons = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: lessons.map((lesson) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: buildLessonCard(
                            lesson['mataPelajaran'] ??
                                'Tidak Ada Mata Pelajaran',
                            lesson['kelas'] ?? 'Tidak Ada Kelas',
                            lesson['namaGuru'] ?? 'Tidak Ada Guru',
                            lesson['id'],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build individual lesson card
  Widget buildLessonCard(
      String subject, String grade, String teacher, String lessonId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DaftarKonten(lessonId: lessonId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFD55),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          subject,
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
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
                                    TambahKonten(lessonId: lessonId)),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    grade,
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      teacher,
                      style: GoogleFonts.poppins(fontSize: 15),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
