import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mother/admins_screen/dashboard.dart';
import 'package:mother/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mother/menu.dart';
import 'package:flutter/services.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          // Store user data in Firestore with a role
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'first_name': _firstNameController.text.trim(),
            'phone_number': _phoneController.text.trim(),
            'email': _emailController.text.trim(),
            'role': 'user', // Default role
            'created_at': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-up successful!')),
          );

          // Navigate based on role
          _navigateBasedOnRole(user.uid);
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateBasedOnRole(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      String role = userDoc['role'];

      if (role == 'admin') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardScreen()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Menu())); // Normal user screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate padding and font size based on screen size
    double horizontalPadding = screenWidth * 0.05; //
    double verticalPadding = screenHeight * 0.02; //
    double fontSize = screenWidth > 600 ? 24 : 18;

    TextStyle textStyle = GoogleFonts.itim(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitle("Registration", textStyle),
                _buildForm(),
                _buildSignUpButton(textStyle),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, TextStyle textStyle) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 2)),
      ),
      child: Text(title, style: textStyle),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
              "Full Name", _firstNameController, "Enter full name", false),
          _buildTextField("Email:", _emailController, "Enter your email", false,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: "assets/images/mail.png"),
          _buildTextField("Phone Number:", _phoneController,
              "Enter your phone number", false,
              keyboardType: TextInputType.phone,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              prefixIcon: "assets/images/phone.png"),
          _buildPasswordField(
              "Password:", _passwordController, "Enter your password"),
          _buildPasswordField("Confirm Password:", _confirmPasswordController,
              "Re-enter your password",
              confirmPassword: true),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      String hint, bool obscureText,
      {TextInputType keyboardType = TextInputType.text,
      String? prefixIcon,
      TextInputFormatter? inputFormatter}) {
    return Column(
      children: [
        Row(
          children: [
            Text(label,
                style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500))
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: const Color(0xFFFEF08A),
              borderRadius: BorderRadius.circular(12)),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatter != null ? [inputFormatter] : null,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: prefixIcon != null ? Image.asset(prefixIcon) : null,
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter $label' : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, String hint,
      {bool confirmPassword = false}) {
    return Column(
      children: [
        Row(
          children: [
            Text(label,
                style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500))
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: const Color(0xFFFEF08A),
              borderRadius: BorderRadius.circular(12)),
          child: TextFormField(
            controller: controller,
            obscureText: confirmPassword
                ? !_isConfirmPasswordVisible
                : !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(24),
              suffixIcon: IconButton(
                icon: Icon(
                  confirmPassword
                      ? (_isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)
                      : (_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                ),
                onPressed: () {
                  setState(() {
                    if (confirmPassword) {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    } else {
                      _isPasswordVisible = !_isPasswordVisible;
                    }
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              if (confirmPassword && value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSignUpButton(TextStyle textStyle) {
    return _isLoading
        ? const CircularProgressIndicator(color: Colors.yellow)
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              backgroundColor: const Color(0xFFF9C51B),
              fixedSize: const Size(109, 47),
            ),
            onPressed: _signUpWithEmailAndPassword,
            child: Text("Sign Up", style: textStyle),
          );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Already have an account? ",
            style: GoogleFonts.itim(
                color: const Color(0xFF3B82F6),
                fontSize: 18,
                fontWeight: FontWeight.w400)),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: Text("Login",
              style: GoogleFonts.itim(
                  color: const Color(0xFF3B82F6),
                  fontSize: 18,
                  fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }
}
