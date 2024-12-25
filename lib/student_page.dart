import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'materi_page.dart';
import 'quiz_page.dart';
import 'profile_siswa.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomeContent(), // Beranda Home
    MateriPage(), // Halaman Materi
    QuizPage(), // Halaman Quiz
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Header setengah lingkaran
          if (_selectedIndex == 0)
            Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFD55),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                  bottomRight: Radius.circular(150),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: const Alignment(-0.6, 0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo-ulilalbab.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.9, 0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileSiswa(),
                          ),
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.person_crop_circle,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Konten Utama
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFFFFD55),
        padding: const EdgeInsets.symmetric(
            vertical: 10.0), // Atur padding horizontal
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home, 'Beranda', 0),
            _buildBottomNavItem(Icons.menu_book, 'Materi', 1),
            _buildBottomNavItem(Icons.quiz, 'Quiz', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Highlight pada latar belakang ikon
          Container(
            width: 70,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Icon(
              icon,
              color: Colors.black,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<bool> _isHovered = List.generate(5, (_) => false);

  // Daftar gambar untuk setiap kartu
  final List<String> _images = [
    'assets/images/TPA_ua.png',
    'assets/images/Logo-TK.png',
    'assets/images/Logo-SDIT.jpg',
    'assets/images/Logo-SMPIT.png',
    'assets/images/Logo-SMAIT.png',
  ];

  // Daftar URL untuk
  final List<String> _urls = [
    'https://tkit-ulilalbabbatam.sch.id/',
    'https://tkit-ulilalbabbatam.sch.id/',
    'https://sditulilalbabbatam.sch.id/',
    'https://smpit-ulilalbabbatam.sch.id/',
    'https://smait-ulilalbabbatam.sch.id/',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ASET-PPDB.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'YAYASAN ULIL ALBAB BATAM',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Merupakan Lembaga Pendidikan Islam Rujukan di Provinsi Kepulauan Riau, alhamdulillah saat ini masih diberi amanah mengelola jenjang Pendidikan Tingkat TKIT, SDIT, SMPIT Dan SMAIT. Adapun lembaga pendidikan ini menyelenggarakan Pendidikan yang Berlandaskan pada Nilai-Nilai Ajaran Islam Dengan Berorientasi pada Terbentuknya Generasi Rabbani yaitu Cerdas, Sholih dan Berkarakter Qur\'ani.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0), // Menambahkan padding dari kiri
              child: Text(
                "Jenjang Pendidikan",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            color: const Color(0xFF13ADDE),
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: _images.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildCard(
                  index: index,
                  image: _images[index],
                  title: index == 0
                      ? 'Taman Penitipan'
                      : index == 1
                          ? 'TKIT Anak Harapan'
                          : index == 2
                              ? 'SDIT'
                              : index == 3
                                  ? 'SMPIT'
                                  : 'SMAIT',
                  url: _urls[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required int index,
    required String image,
    required String title,
    required String url,
  }) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered[index] = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered[index] = false;
        });
      },
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(url); // Pastikan URL dikonversi ke Uri
        if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);} 
        else {
        throw 'Could not launch $url';
      }

        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform:
              Matrix4.translationValues(0, _isHovered[index] ? -10 : 0, 0),
          child: Card(
            elevation: _isHovered[index] ? 10 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      image,
                      height: 97,
                      width: 93,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
