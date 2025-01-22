import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class NewDish extends StatefulWidget {
  const NewDish({super.key});

  @override
  State<NewDish> createState() => _NewDishState();
}

class _NewDishState extends State<NewDish> {
  final TextEditingController _dishController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage != null) {
      setState(() {
        pickedImageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _addDish() async {
    try {
      if (_dishController.text.isEmpty ||
          _priceController.text.isEmpty ||
          _ingredientController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          pickedImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please fill in all fields and upload an image.')),
        );
        return;
      }

      // Convert image to Base64 string
      final bytes = await pickedImageFile!.readAsBytes();
      String base64Image = base64Encode(bytes);

      // Prepare the dish data
      final dishData = {
        'name': _dishController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'ingredients': _ingredientController.text,
        'image': base64Image,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Store in Firestore
      await FirebaseFirestore.instance.collection('menuItems').add(dishData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dish added successfully.')),
      );

      // Clear the input fields
      _dishController.clear();
      _priceController.clear();
      _ingredientController.clear();
      _descriptionController.clear();
      setState(() {
        pickedImageFile = null;
      });

      // Navigate back
      Navigator.of(context).pop();
    } catch (e) {
      print('Failed to add dish: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add dish: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = GoogleFonts.itim(
      color: Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Add a New Dish",
            style: GoogleFonts.itim(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.yellow[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dish Name Field
              Text("Dish Name", style: textStyle),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _dishController,
                hintText: "Enter the dish name",
              ),
              const SizedBox(height: 16),

              // Ingredients Field
              Text("Ingredients", style: textStyle),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _ingredientController,
                hintText: "Enter the ingredients",
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Price Field
              Text("Price", style: textStyle),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _priceController,
                hintText: "Enter the price",
              ),
              const SizedBox(height: 16),

              // Description Field
              Text("Description", style: textStyle),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _descriptionController,
                hintText: "Describe the dish",
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Image Picker
              Text("Image", style: textStyle),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                    ),
                    child: Text(
                      "Choose File",
                      style: GoogleFonts.itim(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    pickedImageFile == null ? "No file chosen" : "File chosen",
                    style: GoogleFonts.itim(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Add Dish Button
              Center(
                child: ElevatedButton(
                  onPressed: _addDish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32),
                  ),
                  child: Text(
                    "Add Dish",
                    style: GoogleFonts.itim(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFEF08A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.itim(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.itim(color: Colors.black54, fontSize: 16),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}
