import 'dart:io' as io; // Untuk Android/iOS
// Untuk Uint8List
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

// Model untuk menyimpan dan mengelola data pengguna
class UserModel {
  final String? id;
  final String name;
  final String email;
  final String kelas;
  final String gender;
  final String nisn;
  final String password;

  const UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.kelas,
    required this.gender,
    required this.nisn,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "kelas": kelas,
      "gender": gender,
      "nisn": nisn,
      "password": password,
    };
  }

  // Mengambil data dari snapshot Firestore
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data['email'] ?? '',
      name: data['name'] ?? 'Tidak ada nama',
      kelas: data['kelas'] ?? 'Tidak ada kelas',
      gender: data['gender'] ?? 'Tidak ada gender',
      nisn: data['nisn'] ?? 'Tidak ada NISN',
      password: data['password'] ?? '',
    );
  }
}

// Halaman Profil
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  io.File? imageFile; // Untuk Android/iOS
  Uint8List? imageBytes; // Untuk Web
  String? imageUrl;
  bool isLoading = false;
  late String currentUserId; // ID pengguna saat ini
  final Logger logger = Logger(); // Instance Logger
  UserModel? userModel; // Model pengguna

  @override
  void initState() {
    super.initState();
    _checkAuthentication(); // Periksa autentikasi saat halaman dibuka
  }

  Future<void> _checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      currentUserId = user.uid; // Ambil ID pengguna yang sedang login
      await _loadUserProfile(); // Memuat profil pengguna
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data() as Map<String, dynamic>;
        userModel = UserModel.fromSnapshot(docSnapshot); // Mengambil data pengguna
        imageUrl = userData['profile_image']; // Ambil URL gambar dari Firestore
        logger.i('Gambar URL: $imageUrl'); // Menggunakan logger
      } else {
        logger.w('Dokumen tidak ditemukan untuk pengguna ini');
      }
    } catch (e) {
      logger.e('Gagal memuat data profil: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat profil pengguna')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      if (kIsWeb) {
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          imageBytes = bytes;
          imageFile = null; // Set null untuk imageFile saat menggunakan web
        });
      } else {
        setState(() {
          imageFile = io.File(pickedImage.path);
          imageBytes = null; // Set null untuk imageBytes saat menggunakan mobile
        });
      }
      await uploadProfile(); // Update profil saat memilih gambar
    }
  }

  Future<void> uploadProfile() async {
    String? newImageUrl;

    if (kIsWeb && imageBytes != null) {
      newImageUrl = await _uploadToFirebase(imageBytes!);
    } else if (imageFile != null) {
      newImageUrl = await _uploadToFirebase(await imageFile!.readAsBytes());
    }

    if (newImageUrl != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(currentUserId).set(
          {
            'profile_image': newImageUrl, // Positional argument yang valid
          },
          SetOptions(merge: true), // Named argument untuk merge
        );
        setState(() {
          imageUrl = newImageUrl; // Update URL gambar di state
        });
        logger.i('Profil berhasil diperbarui');
      } catch (e) {
        logger.e('Gagal memperbarui profil: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui profil pengguna')),
        );
      }
    }
  }

  Future<String?> _uploadToFirebase(Uint8List data) async {
    final destination = 'images/$currentUserId'; // Gunakan ID pengguna sebagai nama file

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      UploadTask uploadTask = ref.putData(data);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      logger.e('Gagal mengunggah gambar: $e');
      return null;
    }
  }

  Widget _buildAvatar() {
    if (kIsWeb && imageBytes != null) {
      return _buildAvatarWithImage(MemoryImage(imageBytes!));
    } else if (imageFile != null) {
      return _buildAvatarWithImage(FileImage(imageFile!));
    } else if (imageUrl != null) {
      return _buildAvatarWithImage(NetworkImage(imageUrl!));
    } else {
      return const CircleAvatar(
        radius: 100,
        child: Icon(
          Icons.camera_alt,
          size: 50,
        ),
      );
    }
  }

  Widget _buildAvatarWithImage(ImageProvider imageProvider) {
    return InkWell(
      onTap: () {
        _showAvatarOptions(); // Menampilkan opsi saat avatar diketuk
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: imageProvider,
            onBackgroundImageError: (exception, stackTrace) {
              logger.e("Gagal memuat gambar profil: $exception");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gagal memuat gambar profil. Pastikan gambar tersedia dan formatnya valid.'),
                ),
              );
            },
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.edit, // Ikon pensil
                size: 18,
                color: Colors.blue, // Warna ikon pensil
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Opsi'),
          content: const Text('Anda dapat mengganti gambar profil.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                pickImage(); // Memanggil pickImage saat opsi dipilih
              },
              child: const Text('Ganti Gambar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserInfo() {
    if (userModel == null) return const SizedBox(); // Menghindari error jika userModel null
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserInfoCard("Nama", userModel!.name),
        _buildUserInfoCard("Email", userModel!.email),
        _buildUserInfoCard("Kelas", userModel!.kelas),
        _buildUserInfoCard("Gender", userModel!.gender),
        _buildUserInfoCard("NISN", userModel!.nisn),
        _buildUserInfoCard("Password", userModel!.password),
      ],
    );
  }

  Widget _buildUserInfoCard(String title, String value) {
    return GestureDetector(
      onTap: () {
        // Tambahkan aksi yang diinginkan saat kartu diketuk (jika diperlukan)
        logger.i('$title: $value diklik');
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Menampilkan loading saat memuat data
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildAvatar(), // Menampilkan avatar
                    const SizedBox(height: 20),
                    _buildUserInfo(), // Menampilkan informasi pengguna
                  ],
                ),
              ),
            ),
    );
  }
}
