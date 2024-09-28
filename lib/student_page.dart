import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'launcher.dart';

class StudentPage extends StatefulWidget { // Mengganti nama menjadi StudentPage
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState(); // Sesuaikan nama state juga
}

class _StudentPageState extends State<StudentPage> { // Mengganti nama state menjadi _StudentPageState
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student"), // Judul yang sesuai
        actions: [
          IconButton(
            onPressed: logout, // Memanggil fungsi logout saat logout button ditekan
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Tampilkan loading saat proses logout
          : const Center(child: Text("Welcome, Student!")), // Menampilkan pesan selamat datang untuk Student
    );
  }

  Future<void> logout() async {
    setState(() {
      _isLoading = true; // Mengubah state menjadi loading
    });

    await FirebaseAuth.instance.signOut(); // Proses logout

    // Pastikan widget masih mounted sebelum navigasi
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LauncherPage(), // Navigasi ke LauncherPage setelah logout
        ),
      );
    }
  }
}
