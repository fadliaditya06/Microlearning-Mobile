import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DaftarSiswaPage extends StatefulWidget {
  const DaftarSiswaPage({super.key});

  @override
  DaftarSiswaPageState createState() => DaftarSiswaPageState();
}

class DaftarSiswaPageState extends State<DaftarSiswaPage> {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _debounce?.cancel();
    super.dispose();
  }

  // Fungsi untuk mengelola perubahan teks pada search box
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  // Stream untuk mengambil data siswa dari Firestore
  Stream<QuerySnapshot> _getUserStream() {
    return userCollection.where('role', isEqualTo: 'Student').snapshots();
  }

  // Fungsi untuk memfilter hasil pencarian secara lokal
  List<QueryDocumentSnapshot> _filterSearchResults(
      List<QueryDocumentSnapshot> documents) {
    if (_searchText.isEmpty) {
      return documents;
    } else {
      return documents.where((doc) {
        var data = doc.data() as Map<String, dynamic>;
        var name = data['name']?.toString().toLowerCase() ?? '';
        return name.contains(_searchText);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                  'Daftar Siswa',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Search Bar
            Align(
              alignment: Alignment.centerRight,
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
                child: SizedBox(
                  width: 180,
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      suffixIcon: const Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF13ADDE), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF13ADDE), width: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // StreamBuilder untuk pengambilan data siswa
            StreamBuilder<QuerySnapshot>(
              stream: _getUserStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
                          )
                        );
                      }

                // Jika data kosong atau tidak ada hasil pencarian
                if (!snapshot.hasData || _filterSearchResults(snapshot.data!.docs).isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      'Tidak ada data siswa yang cocok.',
                      style: GoogleFonts.poppins(fontSize: 17),
                    ),
                  );
                }

                // Filter data siswa berdasarkan pencarian
                var filteredDocs = _filterSearchResults(snapshot.data!.docs);

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var data = filteredDocs[index].data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: Colors.lightBlueAccent),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Foto Profil
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    data['profile_image'] != null &&
                                            data['profile_image'].isNotEmpty
                                        ? NetworkImage(data['profile_image'])
                                        : const AssetImage(
                                                'assets/image/profile.jpg')
                                            as ImageProvider,
                              ),
                              const SizedBox(width: 5),
                              // Garis
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  width: 1,
                                  height: 90,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5),
                              // Data Profil Siswa
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nama: ${data['name'] ?? 'Nama tidak tersedia'}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                      maxLines: null,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'NISN: ${data['nisn'] ?? 'NISN tidak tersedia'}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Jenis Kelamin: ${data['gender'] != null ? (data['gender'] == 'Male' ? 'Laki-laki' : 'Perempuan') : 'Jenis kelamin tidak tersedia'}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Kelas: ${data['kelas'] ?? 'Kelas tidak tersedia'}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
