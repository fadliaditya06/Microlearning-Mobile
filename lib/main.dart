import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:microlearning/launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan bahwa binding widget telah diinisialisasi

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
    print('Firebase initialized successfully.');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  // Ubah timeago menjadi Bahasa Indonesia
  timeago.setLocaleMessages('id', timeago.IdMessages());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microlearning',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 40, 121, 128)),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF13ADDE),
          selectionColor: Color(0xFF13ADDE), 
          selectionHandleColor: Color(0xFF13ADDE), 
        ),
      ),
      home: const LauncherPage(),
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
    );
  }
}
