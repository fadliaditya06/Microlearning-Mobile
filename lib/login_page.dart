import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'register_page.dart';
import 'admin_page.dart';
import 'student_page.dart';
import 'teacher_page.dart';

// Halaman Login
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginForm();
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Logger logger = Logger(); // Inisialisasi logger
  bool _isLoading = false; // Status loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Header Image
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/foto1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 88,
                      height: 200,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/foto2.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 130,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/foto3.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/foto4.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 0,
                      right: 0,
                      top: 160,
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    // Email Field
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email tidak boleh kosong";
                              }
                              if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$").hasMatch(value)) {
                                return "Masukkan email yang valid";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              RegExp regExp = RegExp(r'^.{6,}$');
                              if (value == null || value.isEmpty) {
                                return "Password tidak boleh kosong";
                              }
                              if (!regExp.hasMatch(value)) {
                                return "Masukkan password minimal 6 karakter";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Login Button
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() {
                      _isLoading = true; // Set loading menjadi true
                    });
                    signIn(emailController.text, passwordController.text);
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(143, 148, 251, 1),
                        Color.fromRGBO(143, 148, 251, 6),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Menampilkan CircularProgressIndicator saat loading
              if (_isLoading) // Jika loading aktif
                const CircularProgressIndicator(), // Menampilkan indikator loading
              // Link to Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menandai login pengguna
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Menggunakan userCredential untuk mengambil informasi pengguna
        User? user = userCredential.user;
        logger.i('User signed in: ${user?.email}'); // Menyimpan informasi pengguna ke log

        // Setelah berhasil login, arahkan pengguna berdasarkan peran
        route(context);
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false; // Set loading menjadi false saat error
        });
        if (e.code == 'user-not-found') {
          logger.e('No user found for that email.');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not found')));
        } else if (e.code == 'wrong-password') {
          logger.e('Wrong password provided for that user.');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong password')));
        }
      }
    }
  }

  // Fungsi route untuk mengarahkan sesuai peran pengguna
  void route(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (documentSnapshot.exists) {
          var userRole = documentSnapshot.get('role'); // Change 'rool' to 'role'

          if (userRole == "Teacher") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TeacherPage(), // Arahkan ke halaman Teacher
              ),
            );
          } else if (userRole == "Student") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentPage(), // Arahkan ke halaman Student
              ),
            );
          } else if (userRole == "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminPage(), // Arahkan ke halaman Admin
              ),
            );
          }
        }
      } catch (e) {
        logger.e('Error fetching user role: $e');
      }
    }
  }
}
