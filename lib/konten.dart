import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {

  final Map<String, String> subjectData = {
    'mataPelajaran': 'Biologi',
    'kelas': 'Kelas 10',
    'guru': 'Stupen S. Pd',
    'judulMateri': 'Genetika',
  };

  //Contoh forum diskusi
  final List<Map<String, String>> discussionData = [
    {
      'nama': 'Murid 1',
      'komentar': 'Lorem ipsum',
      'avatar': 'assets/avatar1.png'
    },
    {
      'nama': 'Murid 2',
      'komentar': 'Lorem ipsum',
      'avatar': 'assets/avatar2.png'
    },
    {
      'nama': 'Guru 1',
      'komentar': 'Lorem ipsum',
      'avatar': 'assets/avatar3.png'
    },
  ];

  final TextEditingController _commentController = TextEditingController();

  // Video YouTube
  final YoutubePlayerController _youtubeController = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(
      'https://www.youtube.com/watch?v=pRLzqHAWTcs&t=101s',
    )!,
    flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
  );

  // PDF path (untuk sementara lokal)
  final String pdfPath =
      'assets/pdf/BIOLOGI-PB4.pdf'; // Ganti dengan path PDF yang sesuai

  // Menambahkan komentar baru
  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        discussionData.add({
          'nama': 'User Baru',
          'komentar': _commentController.text,
          'avatar': 'assets/avatar_new.png',
        });
      });
      _commentController.clear();
    }
  }

  // Menghapus komentar
  void _deleteComment(int index) {
    setState(() {
      discussionData.removeAt(index);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[
            // Header setengah lingkaran kuning
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
                // Memastikan teks berada di tengah
                Padding(
                  padding: const EdgeInsets.only(right: 70.0), 
                  child: Text(
                    'Konten Pelajaran',
                    style: GoogleFonts.poppins(
                      fontSize: 25, 
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(), // Tambahkan spacer untuk menjaga keseimbangan
              ],
            ),
          ),

            // Konten utama untuk detail pelajaran
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subjectData['mataPelajaran']!,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subjectData['kelas']!,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subjectData['guru']!,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(color: Colors.yellow, thickness: 1.5),
                  const SizedBox(height: 8),
                  Text(
                    subjectData['judulMateri']!,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // PDF Viewer 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PDF Viewer
                  SizedBox(
                    height: 300,
                    child: SfPdfViewer.asset(pdfPath),
                  ),
                  const SizedBox(height: 16),

                  // Informasi PDF (Nama, Ukuran, dan Tombol Download)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // posisi bayangan
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Informasi Nama PDF dan Ukuran
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Materi Genetika.pdf',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '12 Halaman • 0.97 MB • PDF',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tombol Download PDF
                        IconButton(
                          icon: const Icon(Icons.download,
                              color: Colors.blueAccent),
                          onPressed: () {
                            // Tambahkan aksi untuk mengunduh PDF di sini
                            print('Download PDF');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // YouTube Video Player
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YoutubePlayer(
                    controller: _youtubeController,
                    showVideoProgressIndicator: true,
                    onReady: () => print('Player is ready.'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sejarah Genetika',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Colors.yellow,
                    thickness: 1.5, // Ketebalan garis
                  ),
                ],
              ),
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
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      color: Colors.blue,
                      thickness: 1,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: discussionData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Baris pertama: Avatar, Nama, dan Tombol Hapus
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                        discussionData[index]['avatar']!),
                                  ),
                                  const SizedBox(width: 10),
                                  // Nama Pengguna
                                  Expanded(
                                    child: Text(
                                      discussionData[index]['nama']!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  // Tombol Hapus
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _deleteComment(index),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4), // Spasi antar baris
                              // Baris kedua: Komentar Pengguna
                              Text(
                                discussionData[index]['komentar']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                            ),
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send,
                                    color: Colors.blueAccent),
                                onPressed: _addComment,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}