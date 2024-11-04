import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'kelola_pengguna.dart';
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
  var kelasOptions = ['10', '11', '12']; // Opsi kelas
  var options = ['Student', 'Teacher', 'Admin'];
  String role = "Student";
  String? selectedKelas;

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
                      role == 'Student' ? 'NISN' : 'NIP',
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
                        labelText: role == 'Student' ? 'Input NISN' : 'Input NIP',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan ${role == 'Student' ? 'NISN' : 'NIP'} Anda';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Pilihan kelas hanya untuk role Student
                    if (role == 'Student')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kelas',
                            style: GoogleFonts.poppins(),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            value: selectedKelas,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedKelas = newValue;
                              });
                            },
                            items: kelasOptions.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Pilih Kelas',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Silakan pilih kelas Anda';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),

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
                            color: Colors.white,
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
          ),
        ],
      ),
    );
  }

  Future<void> signUp(String email, String password, String role) async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'name': nameController.text,
          'role': role,
          'password' : password,
          'gender': _selectedGender,
           if (role == 'Student') 'nisn': roleIdController.text, // Menyimpan NISN jika Student
          if (role == 'Admin' || role == 'Teacher') 'nip': roleIdController.text, // Menyimpan NIP jika Admin atau Teacher
          if (role == 'Student') 'kelas': selectedKelas, // Hanya untuk siswa
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun berhasil dibuat')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const KelolaPengguna()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mendaftar, periksa kembali data Anda')),
        );
      }
    }
  }
}
