import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart'; 
import 'profile_page.dart'; 

class UserRepository extends GetxController {
  final Logger logger = Logger(); 
  static User get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Fungsi untuk membuat pengguna baru
  Future<void> create(UserModel user) async {
    try {
      // Menyimpan pengguna dengan email sebagai ID
      await _db.collection("Users").doc(user.email).set(user.toJson());
      logger.i("User created successfully: ${user.email}"); 
    } catch (e) {
      logger.e("Error creating user: $e"); 
    }
  }

  // Fungsi untuk mengambil detail pengguna berdasarkan email
  Future<UserModel?> getUserDetails(String email) async {
    try {
      final snapshot = await _db.collection("Users").where("email", isEqualTo: email).get();
      if (snapshot.docs.isEmpty) {
        logger.w("No user found for email: $email"); // Warning log
        return null; // Menangani kasus tidak ada data
      }
      // Mengambil satu dokumen pengguna
      final userData = UserModel.fromSnapshot(snapshot.docs.single);
      return userData;
    } catch (e) {
      logger.e("Error fetching user details: $e"); 
      return null;
    }
  }

  // Fungsi untuk mengambil semua pengguna
  Future<List<UserModel>> allUsers() async {
    try {
      final snapshot = await _db.collection("Users").get();
      final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      logger.i("Fetched ${userData.length} users."); 
      return userData;
    } catch (e) {
      logger.e("Error fetching all users: $e"); 
      return [];
    }
  }
}
