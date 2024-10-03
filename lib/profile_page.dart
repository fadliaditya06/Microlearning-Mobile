import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fungsi untuk mengubah halaman saat navigasi ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamed(context, '/student_page');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/quiz_page');
    }
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          imageUrl = userDoc['imageUrl'];
          nameController.text = userDoc['name'] ?? '';
          infoController.text = userDoc['info'] ?? '';
        });
      }
    }
  }

  Future<void> pickImage() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengguna belum terautentikasi. Harap masuk terlebih dahulu.'),
          ),
        );
        return;
      }

      if (kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null && result.files.single.bytes != null) {
          await uploadImageToFirebaseWeb(result.files.single.bytes!, user.uid);
        }
      } else {
        XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
        if (res != null) {
          await uploadImageToFirebase(File(res.path), user.uid);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak ada gambar yang dipilih.'),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Gagal memilih gambar: $e"),
        ),
      );
    }
  }

  Future<void> uploadImageToFirebaseWeb(Uint8List imageBytes, String userId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final reference = storageRef.child("images/${DateTime.now().microsecondsSinceEpoch}.png");

      await reference.putData(imageBytes);

      final url = await reference.getDownloadURL();
      setState(() {
        imageUrl = url;
      });

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'imageUrl': url,
        'name': nameController.text,
        'info': infoController.text,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Upload berhasil!"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Gagal mengunggah gambar: $e"),
        ),
      );
    }
  }

  Future<void> uploadImageToFirebase(File image, String userId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final reference = storageRef.child("images/${DateTime.now().microsecondsSinceEpoch}.png");

      await reference.putFile(image);

      final url = await reference.getDownloadURL();
      setState(() {
        imageUrl = url;
      });

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'imageUrl': url,
        'name': nameController.text,
        'info': infoController.text,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Upload berhasil!"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Gagal mengunggah gambar: $e"),
        ),
      );
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/student_page', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                    child: imageUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 224, 243, 57),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.edit),
                  labelText: "Nama",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 11, 11, 11),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: infoController,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.edit),
                  labelText: "Info",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 2, 2, 2),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.lock),
                  labelText: "Password",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Ubah warna latar belakang tombol
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }
}
