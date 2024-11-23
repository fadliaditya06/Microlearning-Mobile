import 'dart:io' as io; // Untuk Android/iOS
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'login_page.dart'; // Pastikan jalur ini benar

class UserModel {
  final String? id;
  final String name;
  final String email;

  final String gender;
  final String nip;
  final String password;

  const UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.gender,
    required this.nip,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "gender": gender,
      "nip": nip,
      "password": password,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data['email'] ?? '',
      name: data['name'] ?? 'Tidak ada nama',
      gender: data['gender'] ?? 'Tidak ada gender',
      nip: data['nip'] ?? 'Tidak ada NIP',
      password: data['password'] ?? '',
    );
  }
}

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  ProfileAdminState createState() => ProfileAdminState();
}

class ProfileAdminState extends State<ProfileAdmin> {
  io.File? imageFile; // Untuk Android/iOS
  Uint8List? imageBytes; // Untuk Web
  String? imageUrl;
  bool isLoading = false;
  late String currentUserId;
  final Logger logger = Logger();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      currentUserId = user.uid;
      await _loadUserProfile();
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login_page');
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
        userModel = UserModel.fromSnapshot(docSnapshot);
        imageUrl = docSnapshot.data()?['profile_image'];
        logger.i('Data pengguna berhasil diambil: ${userModel!.toJson()}');
      } else {
        logger.w('Dokumen tidak ditemukan untuk pengguna ini');
      }
    } catch (e) {
      logger.e('Gagal memuat data profil: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat profil pengguna')),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      if (kIsWeb) {
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          imageBytes = bytes;
          imageFile = null;
        });
      } else {
        setState(() {
          imageFile = io.File(pickedImage.path);
          imageBytes = null;
        });
      }
      await uploadProfile();
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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .set(
          {
            'profile_image': newImageUrl,
          },
          SetOptions(merge: true),
        );
        if (mounted) {
          setState(() {
            imageUrl = newImageUrl;
          });
        }
        logger.i('Profil berhasil diperbarui');
      } catch (e) {
        logger.e('Gagal memperbarui profil: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui profil pengguna')),
        );
      }
    }
  }

  Future<String?> _uploadToFirebase(Uint8List data) async {
    final destination = 'images/$currentUserId';

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
      return InkWell(
        onTap: () {
          pickImage();
        },
        child: const CircleAvatar(
          radius: 100,
          child: Icon(
            Icons.camera_alt,
            size: 50,
          ),
        ),
      );
    }
  }

  Widget _buildAvatarWithImage(ImageProvider imageProvider) {
    return InkWell(
      onTap: () {
        pickImage();
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: imageProvider,
            onBackgroundImageError: (exception, stackTrace) {
              logger.e("Gagal memuat gambar profil: $exception");
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Gagal memuat gambar profil. Pastikan gambar tersedia dan formatnya valid.'),
                ),
              );
            },
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFFFFD55),
              child: Icon(
                Icons.edit,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    if (userModel == null) {
      logger.w('UserModel masih null, tidak ada data untuk ditampilkan');
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserInfoCard("Nama", userModel!.name),
        _buildUserInfoCard("Email", userModel!.email),
        _buildUserInfoCard("Gender", userModel!.gender),
        _buildUserInfoCard("NIP", userModel!.nip),
        _buildUserInfoCard("Password", userModel!.password, isPassword: true),
      ],
    );
  }

  Widget _buildUserInfoCard(String title, String value, {bool isPassword = false}) {
  return GestureDetector(
    onTap: () {
      if (isPassword) {
        // Tidak ada aksi saat password diklik
      } else {
        logger.i('$title: $value diklik');
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        width: 400, 
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15), // Menambahkan jarak antara title dan value
                  Text(
                    isPassword ? '••••••' : value,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Future<void> showLogoutConfirmation() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Header Setengah Lingkaran
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFD55),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150),
                bottomRight: Radius.circular(150),
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Ikon dan teks sejajar kiri
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 25),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 165.0),
                  child: Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Konten Utama di bawah header
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Konten yang di-scroll
                  const SizedBox(height: 20),
                  _buildAvatar(),
                  const SizedBox(height: 20),
                  _buildUserInfo(),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: showLogoutConfirmation,
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
