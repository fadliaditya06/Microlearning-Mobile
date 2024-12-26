import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../admin/dashboard_admin.dart';
import '../siswa/dashboard_siswa.dart';
import '../guru/dashboard_guru.dart';

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
  final Logger logger = Logger();
  bool _isLoading = false;
  String? selectedRole; // Menyimpan peran yang dipilih
  List<String> availableRoles = []; // Daftar peran yang dapat dipilih
  String? correctRole; // Peran yang benar berdasarkan email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFD55),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                  bottomRight: Radius.circular(150),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 90,
                      margin: const EdgeInsets.only(left: 80, right: 80, top: 10, bottom: 10),
                      child: Image.asset('assets/images/logo-ulilalbab.png'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Logo-SMAIT.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "LOGIN",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Dropdown untuk memilih peran
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      hint: Text("Peran",
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.black)),
                      items: ['Student', 'Teacher', 'Admin'].map((role) {
                        String displayValue = '';
                        // Menampilkan peran dalam bahasa indonesia
                        switch (role) {
                          case 'Student':
                            displayValue = 'Siswa';
                            break;
                          case 'Teacher':
                            displayValue = 'Guru';
                            break;
                          case 'Admin':
                            displayValue = 'Admin';
                            break;
                          default:
                            displayValue = role;
                        }
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(displayValue,
                              style: GoogleFonts.poppins(color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value; // Set peran yang dipilih
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color:Color(0xFF13ADDE), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color:Color(0xFF13ADDE), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color:Color(0xFF13ADDE), width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Peran harus dipilih";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Form Input Email
                    TextFormField(
                      controller: emailController,
                      cursorColor: const Color(0xFF13ADDE),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color:Color(0xFF13ADDE), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color:Color(0xFF13ADDE), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color:Color(0xFF13ADDE), width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$")
                            .hasMatch(value)) {
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
                      cursorColor: const Color(0xFF13ADDE),
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color:Color(0xFF13ADDE), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color:Color(0xFF13ADDE), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color:Color(0xFF13ADDE), width: 1),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13ADDE),
                          disabledBackgroundColor: const Color(0xFF13ADDE),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  if (selectedRole == null ||
                                      selectedRole!.isEmpty) {
                                    showErrorModal(
                                        context, 'Peran harus dipilih');
                                    return;
                                  }
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await signIn(emailController.text,
                                      passwordController.text);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menandai login pengguna
  Future<void> signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Ambil email dari database
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        // Mengecek email di database
        if (snapshot.docs.isEmpty) {
          // Jika email tidak ditemukan, tampilkan kesalahan
          showErrorModal(context, 'Email dan password Anda salah');
          return;
        }

        // Mengambil email dari Firestore dan cocokkan dengan case-sensitive
        String databaseEmail = snapshot.docs.first.get('email');

        // Perbandingan case-sensitive
        if (email == databaseEmail) {
          try {
            final UserCredential userCredential =
                await auth.signInWithEmailAndPassword(
              email: email,
              password: password,
            );

            if (userCredential.user != null) {
              // Mengambil data pengguna dari Firestore
              DocumentSnapshot userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userCredential.user!.uid)
                  .get();

              if (userDoc.exists) {
                // Ambil role pengguna dari Firestore
                String userRole = userDoc['role'];

                // Cek apakah role pengguna sesuai dengan yang dipilih
                if (selectedRole == userRole) {
                  navigateToRolePage(userRole, context);
                } else {
                  showErrorModal(context, 'Peran yang Anda pilih tidak sesuai');
                }
              } else {
                showErrorModal(context, 'Data pengguna tidak ditemukan');
              }
            } else {
              showErrorModal(context, 'Login gagal, silakan coba lagi');
            }
          } catch (e) {
            // Menangani kesalahan login dengan email dan password yang salah
            showErrorModal(context, 'Email dan password Anda salah');
          }
        } else {
          // Jika email tidak cocok dengan yang ada di database
          showErrorModal(context, 'Email dan password Anda salah');
        }
      } catch (e) {
        // Menangani kesalahan umum lainnya
        showErrorModal(context, 'Terjadi kesalahan, coba lagi');
      }
    }
  }

  void navigateToRolePage(String userRole, BuildContext context) {
    if (userRole == 'Student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentPage()),
      );
    } else if (userRole == 'Teacher') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TeacherPage()),
      );
    } else if (userRole == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    } else {
      showErrorModal(context, 'Peran yang tidak dikenal');
    }
  }

// Fungsi untuk menampilkan modal
  void showErrorModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kesalahan'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
