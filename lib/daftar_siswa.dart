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

  // Function to manage search input changes
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  // Fungsi untuk mendapatkan stream dengan filter dinamis berdasarkan _searchText
  Stream<QuerySnapshot> _getUserStream() {
    if (_searchText.isEmpty) {
      return userCollection.where('role', isEqualTo: 'Student').snapshots();
    } else {
      return userCollection
          .where('role', isEqualTo: 'Student')
          .where('name', isGreaterThanOrEqualTo: _searchText)
          .where('name', isLessThanOrEqualTo: '$_searchText\uf8ff')
          .snapshots();
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
                  style: GoogleFonts.poppins(fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Search Bar
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
                child: SizedBox(
                  width: 180,
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      suffixIcon: const Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(0xFF13ADDE), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF13ADDE), width: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // StreamBuilder to fetch data based on search query
            StreamBuilder<QuerySnapshot>(
              stream: _getUserStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Tidak ada data siswa yang cocok.',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

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
                              // Profile image
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
                              const SizedBox(width: 12),

                              // Student information
                              SizedBox(
                                width:
                                    100, // fixed width to avoid text overflow
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'] ?? 'Nama tidak tersedia',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      data['nisn'] ?? 'NISN tidak tersedia',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // Divider line
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 1, // Divider thickness
                                  height: 40, // Divider height
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(width: 10),

                              // Additional information
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['gender'] ?? 'Gender tidak tersedia',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Kelas ${data['kelas'] ?? 'Kelas tidak tersedia'}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
