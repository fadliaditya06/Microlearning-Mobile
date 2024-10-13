import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart'; // Tambahkan import untuk logger
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan bahwa binding widget telah diinisialisasi

  // Inisialisasi Logger
  final Logger logger = Logger();

  // Inisialisasi Firebase
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB5CyBpLb-xf4rQFNU3fGutSHxyKyc-5U4",
        appId: "1:382985641726:android:9bb0402c49a62907294faf",
        messagingSenderId: "382985641726",
        projectId: "microlearning-ea3cc",
        storageBucket: "microlearning-ea3cc.appspot.com",
      ),
    );
    logger.i('Firebase initialized successfully.'); // Konfirmasi inisialisasi berhasil
  } catch (e) {
    // Penanganan kesalahan jika Firebase gagal diinisialisasi
    logger.e('Error initializing Firebase: $e'); // Log error
  }

  runApp(const MyApp()); // Jalankan aplikasi utama
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microlearning',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 40, 121, 128)),
        useMaterial3: true,
      ),
      home: const LoginForm(), // Ganti dengan halaman utama aplikasi Anda
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
    );
  }
}
