import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './launcher.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  } catch (e) {
    // Penanganan kesalahan jika Firebase gagal diinisialisasi
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 40, 121, 128)),
        useMaterial3: true,
      ),
      home: const LauncherPage(),
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
    );
  }
}
