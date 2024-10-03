import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'materi_page.dart'; // Import halaman Materi
import 'quiz_page.dart';   // Import halaman Quiz
import 'profile_page.dart'; // Import halaman Profile
import 'launcher.dart';     // Untuk navigasi setelah logout

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  bool _isLoading = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomeContent(), // Halaman Home
    MateriPage(),  // Halaman Materi
    QuizPage(),    // Halaman Quiz
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _showLogoutConfirmationDialog, // Tampilkan modal logout
          icon: const Icon(
            Icons.logout,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(), // Navigasi ke halaman Profile
                ),
              );
            },
            icon: const Icon(
              Icons.person, // Ikon Profile di kanan atas
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book), // Ikon materi
            label: 'Materi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 255, 234, 0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup modal
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup modal
                logout(); // Melakukan logout
              },
              child: const Text('Yakin'),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    setState(() {
      _isLoading = true;
    });

    await FirebaseAuth.instance.signOut();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LauncherPage(),
        ),
      );
    }
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  
  final List<bool> _isHovered = List.generate(5, (_) => false);

  // Daftar gambar untuk setiap kartu
  final List<String> _images = [
    'assets/TPA_ua.png', 
    'assets/Logo-TK.png', 
    'assets/Logo-SDIT.jpg', 
    'assets/Logo-SMPIT.png', 
    'assets/Logo-SMAIT.png', 
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          const Center(
            child: CircleAvatar(
              radius: 60, // Logo size
              backgroundImage: AssetImage('assets/ASET-PPDB.png'), 
            ),
          ),
          const SizedBox(height: 20), 
          const Text(
            'YAYASAN ULIL ALBAB BATAM',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), 
            child: Text(
              'Merupakan Lembaga Pendidikan Islam Rujukan di Provinsi Kepulauan Riau, alhamdulillah saat ini masih diberi amanah mengelola jenjang Pendidikan Tingkat TKIT, SDIT, SMPIT Dan SMAIT. Adapun lembaga pendidikan ini menyelenggarakan Pendidikan yang Berlandaskan pada Nilai-Nilai Ajaran Islam Dengan Berorientasi pada Terbentuknya Generasi Rabbani yaitu Cerdas, Sholih dan Berkarakter Qur\'ani.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Jenjang Pendidikan",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Blue background container
          Container(
            color: Colors.blue, // Blue background
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Jumlah kolom
                childAspectRatio: 1, // Rasio aspek untuk menjaga ukuran kartu
                crossAxisSpacing: 20, // Spacing horizontal antar kartu
                mainAxisSpacing: 20, // Spacing vertikal antar kartu
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
                );
              },
            ),
          ),

          const SizedBox(height: 50), 
          
         
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildScrollingText("Info: Kegiatan akan dimulai pukul 08:00 setiap hari Senin"),
                _buildScrollingText("Info: Pendaftaran untuk kegiatan ekstrakurikuler dibuka sampai akhir bulan ini"),
                _buildScrollingText("Info: Harap membawa buku pelajaran setiap kali masuk kelas"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required int index, required String image, required String title}) {
    return MouseRegion(
      onEnter: (_) {
        // Animasi saat mouse masuk
        setState(() {
          _isHovered[index] = true; 
        });
      },
      onExit: (_) {
        // Kembali ke posisi semula saat mouse keluar
        setState(() {
          _isHovered[index] = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered[index] ? -10 : 0, _isHovered[index] ? 10 : 0), // Memberikan efek kedalaman
        child: Card(
          elevation: _isHovered[index] ? 10 : 4, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40, // Logo size
                  backgroundImage: AssetImage(image), 
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollingText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
