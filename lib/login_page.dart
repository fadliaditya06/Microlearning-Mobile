import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  String? selectedRole; // Menyimpan peran yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Header Setengah Lingkaran
            Container(
              height: 150, 
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 253, 240, 69), 
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150), 
                  bottomRight: Radius.circular(150), 
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -30,
                    left: 15,
                    width: 200,
                    height: 200,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo-ulilalbab.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), 

            // Foto Login 
            Container(
              width: 500, 
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20), // Jarak antara foto dan teks
            // Tulisan "LOGIN"
            const Text(
              "LOGIN",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Jarak antara teks dan input form

            // Form Input
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  // Dropdown untuk memilih peran
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    hint: const Text("Peran"),
                    items: const [
                      DropdownMenuItem(
                        value: "Student",
                        child: Text("Siswa"),
                      ),
                      DropdownMenuItem(
                        value: "Teacher",
                        child: Text("Guru"),
                      ),
                      DropdownMenuItem(
                        value: "Admin",
                        child: Text("Admin"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value; // Set peran yang dipilih
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), 
                        borderSide: const BorderSide(color: Colors.blue), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), 
                        borderSide: const BorderSide(color: Colors.blue, width: 1), 
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), 
                        borderSide: const BorderSide(color: Colors.blue, width: 1), 
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Silakan pilih peran";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Form Input Email 
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), 
                        borderSide: const BorderSide(color: Colors.blue), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), 
                        borderSide: const BorderSide(color: Colors.blue, width: 1), 
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), 
                        borderSide: const BorderSide(color: Colors.blue, width: 1), 
                      ),
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
                  const SizedBox(height: 20),
                  // Form Input Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Radius sudut
                        borderSide: const BorderSide(color: Colors.blue), // Warna garis biru
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Radius sudut
                        borderSide: const BorderSide(color: Colors.blue, width: 1), // Warna garis biru saat fokus
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Radius sudut
                        borderSide: const BorderSide(color: Colors.blue, width: 1), // Warna garis biru saat tidak fokus
                      ),
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
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 6) {
                        return "Masukkan password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Tombol Login 
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        // Redirect ke halaman siswa tanpa autentikasi
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Menampilkan CircularProgressIndicator saat loading
                  if (_isLoading) const CircularProgressIndicator(),
                  // Link to Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(""),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text(
                          "",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
          var userRole = documentSnapshot.get('role');

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