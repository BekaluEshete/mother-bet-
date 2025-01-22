import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  File? pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.2, // Responsive radius
                  backgroundColor: Colors.grey,
                  foregroundImage: const AssetImage("assets/images/beke.jpg"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bekalu Eshete",
                        style: GoogleFonts.itim(
                          color: Colors.black,
                          fontSize: screenWidth * 0.08, // Responsive font size
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "bekalueshete@gmail.com",
                        style: GoogleFonts.itim(
                          color: Colors.black,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow("Age :", "22", screenWidth),
            _buildInfoRow("Status :", "Logged in", screenWidth),
            _buildInfoRow("Joined At :", "Feb - 06- 24", screenWidth),
            _buildInfoRow("Last Seen At :", "Feb - 23- 24", screenWidth),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
                backgroundColor: const Color(0xFFF9C51B),
                fixedSize: Size(screenWidth, 49), // Use screenWidth
              ),
              child: Text(
                "See History",
                style: GoogleFonts.itim(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05, // Responsive font size
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$title ",
                  style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.itim(
                    color: const Color(0xBF000000),
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
