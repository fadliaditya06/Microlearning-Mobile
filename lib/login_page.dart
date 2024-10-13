import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'student_page.dart';

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
  bool _isLoading = false; // Status loading
  String? selectedRole; // Menyimpan peran yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Header dan Logo
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
                  Positioned(
                    top: -30,
                    left: 15,
                    width: 200,
                    height: 200,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo-ulilalbab.png'),
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
                  image: AssetImage('assets/images/login.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20), // Jarak antara foto dan teks

            // Tulisan "LOGIN"
            Text(
              "LOGIN",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5), // Jarak antara teks dan input form

            // Form Input
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form( 
                key: _formKey, 
                child: Column(
                  children: <Widget>[
                    // Dropdown untuk memilih peran
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      hint: Text("Peran", style: GoogleFonts.poppins(fontSize: 15)),
                      style: GoogleFonts.poppins(fontSize: 15), 
                      items: [
                        DropdownMenuItem(
                          value: "Student",
                          child: Text("Siswa", style: GoogleFonts.poppins()), 
                        ),
                        DropdownMenuItem(
                          value: "Teacher",
                          child: Text("Guru", style: GoogleFonts.poppins()), 
                        ),
                        DropdownMenuItem(
                          value: "Admin",
                          child: Text("Admin", style: GoogleFonts.poppins()), 
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
                    ),
                    const SizedBox(height: 20),

                    // Form Input Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.poppins(fontSize: 15),
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

                    // Form Input Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.poppins(fontSize: 15),
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
                          // Validasi form sebelum login
                          if (_formKey.currentState!.validate()) {
                            // Redirect ke halaman siswa tanpa autentikasi
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudentPage(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}