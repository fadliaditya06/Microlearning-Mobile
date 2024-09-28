import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'launcher.dart';

final _logger = Logger('TeacherPage'); // Ubah nama logger untuk mencerminkan kelas baru

class TeacherPage extends StatefulWidget { // Mengganti nama menjadi TeacherPage
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState(); // Sesuaikan nama state juga
}

class _TeacherPageState extends State<TeacherPage> { // Mengganti nama state menjadi _TeacherPageState
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher"), // Judul halaman
        actions: [
          IconButton(
            onPressed: () {
              logout(); // Memanggil fungsi logout saat logout button ditekan
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(child: Text("Welcome, Teacher!")), // Menampilkan pesan selamat datang untuk Teacher
    );
  }

  Future<void> logout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), // Menampilkan indikator loading saat logout
        );
      },
    );

    try {
      await FirebaseAuth.instance.signOut(); // Proses logout

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LauncherPage()), // Navigasi ke LauncherPage setelah logout
      );
    } catch (e) {
      _logger.severe("Error signing out", e); // Gunakan logger untuk mencatat error
    } finally {
      if (mounted) {
        Navigator.of(context).pop(); // Menutup dialog loading setelah logout
      }
    }
  }
}
