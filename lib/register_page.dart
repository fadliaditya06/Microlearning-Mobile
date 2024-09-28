import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  bool showProgress = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool _isObscure = true;

  var options = ['Student', 'Teacher', 'Admin'];
  String _currentItemSelected = "Student";
  String role = "Student";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username (Email)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
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
              const SizedBox(height: 20), // Spacing between fields
              DropdownButtonFormField<String>(
                value: _currentItemSelected,
                onChanged: (String? newValue) {
                  setState(() {
                    _currentItemSelected = newValue!;
                    role = newValue;
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
              const SizedBox(height: 20), // Spacing before the button
              ElevatedButton(
                onPressed: () async {
                  await signUp(usernameController.text, passwordController.text, role);
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
      showProgress = true; // Show loading indicator
    });

    if (_formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        await _auth.createUserWithEmailAndPassword(
          email: email, // Use email directly from input
          password: password,
        );

        // Save user data to Firestore
        await postDetailsToFirestore(email, role); // Call the method to save user data

        // Navigate to login page or home page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      } finally {
        setState(() {
          showProgress = false; // Hide loading indicator
        });
      }
    } else {
      setState(() {
        showProgress = false; // Hide loading indicator if form is invalid
      });
    }
  }

  Future<void> postDetailsToFirestore(String email, String role) async {
    User? user = _auth.currentUser; // Get current user
    CollectionReference ref = FirebaseFirestore.instance.collection('users');

    // Save user data
    await ref.doc(user!.uid).set({
      'email': email, // Use the email directly from input
      'role': role,
    });
  }
}
