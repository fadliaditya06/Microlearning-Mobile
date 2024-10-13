import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:google_fonts/google_fonts.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  bool showProgress = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleIdController = TextEditingController(); // Digunakan untuk NISN/NIP
  String _selectedGender = 'Male'; // Pilihan gender default

  bool _isObscure = true;

  var options = ['Student', 'Teacher', 'Admin'];
  String role = "Student"; // Role default

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
            child: Center(
              child: Text(
                'Tambah Pengguna', 
                style: GoogleFonts.poppins(
                  fontSize: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Konten Form
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Dropdown untuk memilih role (Student, Teacher, Admin)
                    Text(
                      'Peran',
                      style: GoogleFonts.poppins(), 
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: role,
                      onChanged: (String? newValue) {
                        setState(() {
                          role = newValue!;
                        });
                      },
                      items: options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(), 
                          ),
                        );
                      }).toList(),
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
                    ),
                    const SizedBox(height: 20),

                    // Input email
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(), 
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: emailController,
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
                        labelText: 'Input Email',
                        labelStyle: GoogleFonts.poppins(), 
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan email Anda';
                        }
                        return null;
                      },
                      
                    ),
                    const SizedBox(height: 20),
                    // Input nama
                    Text(
                      'Nama',
                      style: GoogleFonts.poppins(), 
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: nameController,
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
                        labelText: 'Input Nama',
                        labelStyle: GoogleFonts.poppins(), 
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan nama Anda';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Input NISN/NIP berdasarkan role yang dipilih
                    Text(
                      'NISN/NIP',
                      style: GoogleFonts.poppins(), 
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: roleIdController,
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
                        labelText: role == 'Student' ? 'Input NISN' : 'Input NIP',
                        labelStyle: GoogleFonts.poppins(), // Font Poppins
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan ${role == 'Student' ? 'NISN' : 'NIP'} Anda';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20), 

                    // Pilihan Gender dengan RadioListTile
                    Text(
                      'Jenis Kelamin',
                      style: GoogleFonts.poppins(), 
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: const EdgeInsets.only(left: -10), 
                            title: Text('Laki-laki', style: GoogleFonts.poppins()), 
                            value: 'Male',
                            activeColor: Colors.black, 
                            groupValue: _selectedGender,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: const EdgeInsets.only(left: -10), 
                            title: Text('Perempuan', style: GoogleFonts.poppins()), 
                            value: 'Female',
                            activeColor: Colors.black, 
                            groupValue: _selectedGender,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), 

                    // Input password
                    Text(
                      'Password',
                      style: GoogleFonts.poppins(), 
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
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
                        labelText: 'Input Password',
                        labelStyle: GoogleFonts.poppins(), 
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
                          return 'Silakan masukkan password Anda';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20), 
                    // Input konfirmasi password
                    Text(
                      'Konfirmasi Password',
                      style: GoogleFonts.poppins(), 
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: confirmPassController,
                      obscureText: _isObscure,
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
                        labelText: 'Input Konfirmasi Password',
                        labelStyle: GoogleFonts.poppins(), 
                      ),
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20), 

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      onPressed: () async {
                        await signUp(emailController.text, passwordController.text, role);
                      },
                      child: Text(
                        "Simpan",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
                    if (showProgress) 
                    const SizedBox(
                      height: 50, 
                      child: Center(
                        child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signUp(String email, String password, String role) async {
    setState(() {
      showProgress = true; // Tampilkan indikator loading
    });

    if (_formKey.currentState!.validate()) {
      try {
        // Buat pengguna dengan email dan password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Simpan data pengguna ke Firestore
        await postDetailsToFirestore(userCredential.user!.uid); // Panggil metode untuk menyimpan data pengguna

        // Navigasi ke halaman login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Tangani kesalahan di sini
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registrasi gagal')),
        );
      } finally {
        setState(() {
          showProgress = false; // Sembunyikan indikator loading
        });
      }
    } else {
      setState(() {
        showProgress = false; // Sembunyikan indikator loading jika form tidak valid
      });
    }
  }

  Future<void> postDetailsToFirestore(String uid) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');

    // Simpan data pengguna
    await ref.doc(uid).set({
      'name': nameController.text, // Simpan nama
      'email': emailController.text,
      'password': passwordController.text, // Simpan email
      'role': role, // Simpan role
      'gender': _selectedGender, // Simpan gender
      if (role == 'Student') 'nisn': roleIdController.text, // Simpan NISN jika role adalah Student
      if (role == 'Teacher' || role == 'Admin') 'nip': roleIdController.text, // Simpan NIP jika role adalah Teacher/Admin
    });
  }
}
