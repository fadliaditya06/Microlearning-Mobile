import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:timeago/timeago.dart' as timeago;

class KontenPelajaranPage extends StatefulWidget {
  const KontenPelajaranPage({super.key, required this.subabId});

  final String subabId;

  @override
  _KontenPelajaranPageState createState() => _KontenPelajaranPageState();
}

class _KontenPelajaranPageState extends State<KontenPelajaranPage> {
  late String currentUserId;
  String? imageUrl;
  String? name;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final TextEditingController _komentarController = TextEditingController();
  late Future<DocumentSnapshot> _kontenFuture;

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _kontenFuture = FirebaseFirestore.instance
        .collection('konten')
        .doc(widget.subabId)
        .get();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      currentUserId = user.uid;
      await _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      DocumentSnapshot userDoc = await userCollection.doc(currentUserId).get();
      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'] as String?;
          imageUrl = userDoc['profile_image'] as String?;
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  void _tambahKomentar() {
    if (_komentarController.text.isNotEmpty) {
      String userName = name ?? 'Anonim';
      String userImage = imageUrl ?? 'https://www.example.com/default-avatar.png';
      FirebaseFirestore.instance.collection('komentar').add({
        'subabId': widget.subabId,
        'komentar': _komentarController.text,
        'name': userName,
        'profile_image': userImage,
        'uid': FirebaseAuth.instance.currentUser?.uid, // Menyimpan UID pengguna
        'timestamp': FieldValue.serverTimestamp(),
      });
      _komentarController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _kontenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
              )
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final String judulSubBab = data['judulSubBab'] ?? '';
          final String mataPelajaranUpperCase = data['mataPelajaran'] ?? '';
          final String namaGuru = data['namaGuru'] ?? '';
          final String kelas = data['kelas'] ?? '';
          final String pdfUrl = data['pdfUrl'] ?? '';
          final String linkVideo = data['linkVideo'] ?? '';

          String? videoId;
          if (linkVideo.isNotEmpty) {
            videoId = YoutubePlayer.convertUrlToId(linkVideo);
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          // Menampilkan judulSubBab di tengah
                            Padding(
                              padding: const EdgeInsets.only(right: 70.0),
                              child: Center(
                                child: Text(
                                  "Konten Pelajaran",
                                  style: GoogleFonts.poppins(
                                    fontSize: 25,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mataPelajaranUpperCase,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            kelas,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            namaGuru,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    // Garis 
                    const Divider(color: Colors.yellow, thickness: 1.5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Text(
                        judulSubBab,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    // Materi PDF
                    if (pdfUrl.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 300,
                          child: SfPdfViewer.network(
                            pdfUrl,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    // Tombol buka PDF
                    if (pdfUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PdfViewerPage(pdfUrl: pdfUrl),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.redAccent,
                                  size: 30,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    "Materi $judulSubBab.pdf",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    // YouTube Player
                    if (videoId != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: videoId,
                            flags: const YoutubePlayerFlags(autoPlay: false),
                          ),
                          showVideoProgressIndicator: true,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Video Materi $judulSubBab',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      color: Colors.yellow,
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 16),
                    // Forum Diskusi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF13ADDE)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Forum Diskusi',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            const Divider(
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('komentar')
                                  .where('subabId', isEqualTo: widget.subabId)
                                  .orderBy('timestamp', descending: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(Colors.blue)
                                            )
                                          );
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text(
                                        'Terjadi kesalahan. Silakan coba lagi.'),
                                  );
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Belum ada komentar.',
                                    ),
                                  ));
                                }
                                return SizedBox(
                                  height: 300,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var komentar = snapshot.data!.docs[index];
                                      String komentarUid = komentar['uid'];
                                      return FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(komentarUid)
                                            .get(),
                                        builder: (context, userSnapshot) {
                                          if (userSnapshot.connectionState ==
                                              ConnectionState.waiting) {}
                                          if (userSnapshot.hasError) {
                                            return const Center(
                                                child: Text(
                                                    'Gagal mengambil data pengguna.')
                                                  );
                                          }
                                          // Memeriksa data pengguna
                                          var userData = userSnapshot.data
                                              ?.data() as Map<String, dynamic>?;

                                          String name = userData?['name'] ?? 'Anonim';
                                          String userImage = userData?['profile_image'] ?? ''; 
                                          var timestamp = komentar['timestamp'];
                                          DateTime? dateTime;
                                          if (timestamp != null) {
                                            dateTime = timestamp.toDate();
                                          }
                                          var timeAgo = dateTime != null
                                              ? timeago.format(dateTime, locale: 'id') : "Waktu tidak tersedia";
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                              ),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: userImage.isNotEmpty
                                                      ? NetworkImage(userImage)
                                                      : const AssetImage
                                                      ('assets/images/default_avatar.png')
                                                          as ImageProvider, 
                                                ),
                                                title: Text(
                                                  komentar['name'] ?? name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      komentar['komentar'] ?? '',
                                                      style: const TextStyle(fontSize: 12),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Dikirim $timeAgo',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                trailing: FirebaseAuth.instance
                                                            .currentUser?.uid ==
                                                        komentar['uid']
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red),
                                                        onPressed: () async {
                                                          bool? confirmDelete =
                                                              await showDialog<
                                                                  bool>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Konfirmasi Hapus'),
                                                                content: const Text(
                                                                    'Apakah Anda yakin ingin menghapus komentar ini?'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            false),
                                                                    child: const Text(
                                                                        'Batal',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black)),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            true),
                                                                    child: const Text(
                                                                        'Hapus',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black)),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );

                                                          if (confirmDelete ==
                                                              true) {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'komentar')
                                                                .doc(
                                                                    komentar.id)
                                                                .delete();
                                                          }
                                                        },
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    style: const TextStyle(fontSize: 14),
                                    controller: _komentarController,
                                    cursorColor: const Color(0xFF13ADDE),
                                    decoration: InputDecoration(
                                      hintText: 'Tambah Komentar',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF13ADDE),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF13ADDE),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF13ADDE),
                                          width: 2.0,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 14),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.send,
                                            color: Color(0xFF13ADDE)),
                                        onPressed: () async {
                                          if (_komentarController.text
                                              .trim()
                                              .isEmpty) return;
                                          _tambahKomentar();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Halaman untuk menampilkan PDF
class PdfViewerPage extends StatelessWidget {
  const PdfViewerPage({super.key, required this.pdfUrl});

  final String pdfUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
