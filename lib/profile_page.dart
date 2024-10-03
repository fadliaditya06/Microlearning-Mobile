import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart'; // Untuk web
import 'package:flutter/foundation.dart' show kIsWeb; // Untuk mendeteksi platform
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Untuk Android/iOS
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk autentikasi Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk Firestore

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;

  // Kontrol untuk input nama, info, dan password
  final TextEditingController nameController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Mengambil data pengguna dari Firestore
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

  // Fungsi untuk memilih gambar
  Future<void> pickImage() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Jika pengguna belum terautentikasi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengguna belum terautentikasi. Harap masuk terlebih dahulu.'),
          ),
        );
        return;
      }

      if (kIsWeb) {
        // Logika untuk platform Web
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null && result.files.single.bytes != null) {
          await uploadImageToFirebaseWeb(result.files.single.bytes!, user.uid);
        }
      } else {
        // Logika untuk platform mobile (Android/iOS)
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

  // Fungsi untuk mengunggah gambar di Firebase (untuk web)
  Future<void> uploadImageToFirebaseWeb(Uint8List imageBytes, String userId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final reference = storageRef.child("images/${DateTime.now().microsecondsSinceEpoch}.png");

      // Mengunggah gambar dari bytes
      await reference.putData(imageBytes);

      // Dapatkan URL download
      final url = await reference.getDownloadURL();
      setState(() {
        imageUrl = url; // Perbarui state dengan URL gambar
      });

      // Simpan URL ke Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'imageUrl': url,
        'name': nameController.text,
        'info': infoController.text,
      }, SetOptions(merge: true)); // Merge untuk tidak menghapus field lainnya

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

  // Fungsi untuk mengunggah gambar di Firebase (untuk mobile)
  Future<void> uploadImageToFirebase(File image, String userId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final reference = storageRef.child("images/${DateTime.now().microsecondsSinceEpoch}.png");

      // Mengunggah file gambar
      await reference.putFile(image);

      // Dapatkan URL download
      final url = await reference.getDownloadURL();
      setState(() {
        imageUrl = url; // Perbarui state dengan URL gambar
      });

      // Simpan URL ke Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'imageUrl': url,
        'name': nameController.text,
        'info': infoController.text,
      }, SetOptions(merge: true)); // Merge untuk tidak menghapus field lainnya

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
            ],
          ),
        ),
      ),
    );
  }
}
