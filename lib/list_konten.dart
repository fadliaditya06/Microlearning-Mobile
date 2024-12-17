import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:microlearning/konten.dart';

class ListKonten extends StatefulWidget {
  final String kelas;
  final String mataPelajaran;
  final String idlesson;

  const ListKonten({
    super.key,
    required this.kelas,
    required this.mataPelajaran,
    required this.idlesson,
  });

  @override
  ListKontenState createState() => ListKontenState();
}

class ListKontenState extends State<ListKonten> {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('konten');
  String searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  Stream<QuerySnapshot> _getSubab() {
    return userCollection
        .where('kelas', isEqualTo: widget.kelas)
        .where('mataPelajaran', isEqualTo: widget.mataPelajaran.toUpperCase())
        .snapshots();
  }

  // Fungsi untuk memfilter data berdasarkan query pencarian
  List<QueryDocumentSnapshot> _filterSubab(
      List<QueryDocumentSnapshot> subabList) {
    if (searchQuery.isEmpty) {
      return subabList;
    }
    return subabList.where((subab) {
      String judulSubBab = subab['judulSubBab'] ?? '';
      return judulSubBab.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

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
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 25),
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
                    style: GoogleFonts.poppins(
                        fontSize: 25,
                        color:
                            Colors.black), // Mengubah warna teks menjadi hitam
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Search Bar
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
              child: SizedBox(
                width: 180,
                height: 40,
                child: TextField(
                  controller: _searchController,
                  cursorColor: const Color(0xFF13ADDE),
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    suffixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Color(0xFF13ADDE), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Color(0xFF13ADDE), width: 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // StreamBuilder untuk menampilkan data subab
          StreamBuilder<QuerySnapshot>(
            stream: _getSubab(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
                )
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      'Konten tidak ditemukan.',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                );
              }

              var subabList = snapshot.data!.docs;

              // Memfilter subab berdasarkan query pencarian
              var filteredSubabList = _filterSubab(subabList);

              if (filteredSubabList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      'Tidak ada konten yang cocok.',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16), 
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredSubabList.length,
                  itemBuilder: (context, index) {
                    var subab = filteredSubabList[index];
                    String judulSubBab = subab['judulSubBab'] ?? 'No Title';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0), 
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KontenPelajaranPage(
                                subabId: subab.id, // Mengirimkan id subab
                              ),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF13ADDE),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                judulSubBab,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
