import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  File? pickedImageFile;
  bool isProfileExpanded = false; // For Update Profile Picture
  bool isPasswordExpanded = false; // For Change Password
  late Box userBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    userBox = await Hive.openBox('userBox');
    _loadProfileImage();
  }

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
    _saveProfileImage(pickedImageFile!);
  }

  // Convert image to Uint8List and save to Hive
  void _saveProfileImage(File imageFile) async {
    Uint8List imageBytes = await imageFile.readAsBytes();
    await userBox.put('profileImage', imageBytes);
  }

  // Load image from Hive
  void _loadProfileImage() {
    final imageBytes = userBox.get('profileImage');
    if (imageBytes != null) {
      setState(() {
        pickedImageFile = File.fromRawPath(imageBytes);
      });
    }
  }

  // Function to handle password update logic
  void _updatePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog("Please fill in all the fields.");
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorDialog("New password and confirm password do not match.");
      return;
    }

    if (newPassword.length < 6) {
      _showErrorDialog("Password must be at least 6 characters.");
      return;
    }

    // Get the currently signed-in user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorDialog("No user is currently signed in.");
      return;
    }

    try {
      // Reauthenticate the user with their old password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);

      _showSuccessDialog("Password updated successfully!");
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? "Failed to update password.");
    } catch (e) {
      _showErrorDialog("An error occurred while updating the password.");
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: deviceWidth * 0.14,
              left: 16,
              right: 16,
              bottom: deviceHeight * 0.12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                foregroundImage: pickedImageFile != null
                    ? FileImage(pickedImageFile!)
                    : const AssetImage("assets/images/beke.jpg")
                        as ImageProvider,
              ),
              const SizedBox(height: 20),
              Text(
                "bekalu@gmail.com",
                style: GoogleFonts.itim(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    "Update Profile Picture",
                    style: GoogleFonts.itim(fontSize: 18, color: Colors.black),
                  ),
                  trailing: Icon(
                    isProfileExpanded
                        ? Icons.arrow_drop_up_outlined
                        : Icons.arrow_drop_down,
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      isProfileExpanded = expanded;
                    });
                  },
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 230, 225, 214),
                              shape: const RoundedRectangleBorder()),
                          child: const Text("Choose File"),
                        ),
                        const SizedBox(width: 8),
                        pickedImageFile == null
                            ? const Text("No file chosen")
                            : const Text("File chosen"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Profile update logic goes here
                          if (pickedImageFile != null) {
                            _showSuccessDialog(
                                "Profile Picture is updated sucessfully");
                          } else {
                            _showSuccessDialog(
                                "Profile Picture is not selected ");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    "Change Password",
                    style: GoogleFonts.itim(fontSize: 18, color: Colors.black),
                  ),
                  trailing: Icon(
                    isPasswordExpanded
                        ? Icons.arrow_drop_up_outlined
                        : Icons.arrow_drop_down,
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      isPasswordExpanded = expanded;
                    });
                  },
                  children: [
                    // Old Password Field
                    _buildPasswordField(
                      controller: _oldPasswordController,
                      hint: "Enter old password",
                    ),
                    const SizedBox(height: 16),
                    // New Password Field
                    _buildPasswordField(
                      controller: _newPasswordController,
                      hint: "Enter new password",
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password Field
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      hint: "Confirm password",
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Change password",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable password input field
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFEF08A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: TextFormField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
