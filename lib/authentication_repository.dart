import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AuthenticationRepository extends GetxController {
  final Logger logger = Logger(); // Inisialisasi Logger
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Mengambil pengguna saat ini
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _firebaseAuth.authStateChanges().listen((user) {
      firebaseUser.value = user; // Memperbarui nilai pengguna
      logger.i('User state changed: ${user?.email}'); // Log perubahan status pengguna
    });
  }

  // Fungsi untuk login dengan email dan password
  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      logger.i('User logged in: $email'); // Log pengguna yang berhasil login
    } catch (e) {
      logger.e('Login error: $e'); // Log kesalahan login
      rethrow; // Mengeluarkan kesalahan
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    logger.i('User logged out'); // Log pengguna yang keluar
  }

  // Fungsi untuk mendaftar pengguna baru
  Future<void> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      logger.i('User registered: $email'); // Log pengguna yang berhasil mendaftar
    } catch (e) {
      logger.e('Registration error: $e'); // Log kesalahan pendaftaran
      rethrow; // Mengeluarkan kesalahan
    }
  }
}
