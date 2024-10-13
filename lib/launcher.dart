import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import './login_page.dart'; // Import halaman login yang baru
class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});

  @override
  LauncherPageState createState() => LauncherPageState();
}

class LauncherPageState extends State<LauncherPage> {
  final List<String> words = ['Selamat Datang', 'Pengguna'];
  final List<double> positions = [-100.0, -100.0];

  @override
  void initState() {
    super.initState();
    startLaunching();
    animateWords();
  }

  Future<void> startLaunching() async {
    const duration = Duration(seconds: 5);
    Timer(duration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const LoginPage(); // Navigasi ke halaman login
        }));
      }
    });
  }

  void animateWords() async {
    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          positions[i] = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xfffbb448),
      ),
    );
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/ASET-PPDB.png",
                  height: 120.0,
                  width: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(words.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Transform.translate(
                      offset: Offset(positions[index], 0),
                      child: AnimatedOpacity(
                        opacity: positions[index] == 0.0 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          words[index],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
