import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'launcher.dart';

class AdminPage extends StatefulWidget { // Nama widget diubah menjadi AdminPage untuk konsistensi
  const AdminPage({super.key}); // Constructor yang benar

  @override
  State<AdminPage> createState() => _AdminPageState(); // Sesuaikan nama state
}

class _AdminPageState extends State<AdminPage> { // Nama state yang benar
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"), // Judul halaman yang benar
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Menampilkan indikator loading
          : const Center(child: Text("Welcome, Admin!")), // Menampilkan teks selamat datang admin
    );
  }

  Future<void> logout() async {
    setState(() {
      _isLoading = true; // Mengaktifkan state loading
    });

    await FirebaseAuth.instance.signOut(); // Melakukan proses logout

    // Pastikan untuk melakukan navigasi hanya jika widget masih mounted
    if (mounted) {
      setState(() {
        _isLoading = false; // Nonaktifkan loading setelah logout
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LauncherPage(), // Navigasi ke LauncherPage setelah logout
        ),
      );
    }
  }
}
