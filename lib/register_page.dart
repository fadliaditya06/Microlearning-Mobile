import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

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

  var kelasOptions = ['10', '11', '12']; // Opsi kelas
  String? selectedkelas; // Kelas yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: SingleChildScrollView( // Tambahkan SingleChildScrollView untuk fitur scroll
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Input nama
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // Input email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              // Input password
              TextFormField(
                controller: passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: 'Password',
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
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              // Input konfirmasi password
              TextFormField(
                controller: confirmPassController,
                obscureText: _isObscure,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Pilihan Gender dengan RadioListTile
              const Text('Select Gender'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
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
                      title: const Text('Female'),
                      value: 'Female',
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

              // Dropdown untuk memilih role (Student, Teacher, Admin)
              DropdownButtonFormField<String>(
                value: role,
                onChanged: (String? newValue) {
                  setState(() {
                    role = newValue!;
                    if (role != 'Student') {
                      selectedkelas = null; // Reset kelas jika bukan student
                    }
                  });
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Select Role',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20), // Spasi antara field

              // Tampilkan NISN atau NIP berdasarkan role yang dipilih
              if (role == 'Student') ...[
                TextFormField(
                  controller: roleIdController,
                  decoration: const InputDecoration(labelText: 'NISN'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your NISN';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20), // Spasi sebelum pemilihan kelas
                DropdownButtonFormField<String>(
                  value: selectedkelas,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedkelas = newValue; // Simpan kelas yang dipilih
                    });
                  },
                  items: kelasOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Pilih kelas',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your class';
                    }
                    return null;
                  },
                ),
              ] else if (role == 'Teacher' || role == 'Admin') ...[
                TextFormField(
                  controller: roleIdController,
                  decoration: const InputDecoration(labelText: 'NIP'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your NIP';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20), // Spasi sebelum tombol

              ElevatedButton(
                onPressed: () async {
                  await signUp(emailController.text, passwordController.text, role);
                },
                child: const Text('Register'),
              ),
              if (showProgress) const CircularProgressIndicator(),
            ],
          ),
        ),
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
          SnackBar(content: Text(e.message ?? 'Registration failed')),
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
      if (role == 'Student') 'kelas': selectedkelas, // Simpan kelas jika role adalah Student
    });
  }
}
