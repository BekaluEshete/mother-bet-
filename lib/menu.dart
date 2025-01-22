import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mother/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mother/plate.dart';
import 'package:path_provider/path_provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  TextStyle content = GoogleFonts.itim(
    color: const Color(0xBF000000),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  //final List<Map<String, dynamic>> _reviews = [];
  final TextEditingController _commentController = TextEditingController();
  double _currentRating = 3;
  String _firstName =
      'Anonymous'; // Class-level variable to store user's first name.

  Future<void> _fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;
          setState(() {
            _firstName = userData?['first_name'] ?? 'Anonymous';
          });
        }
      }
    } catch (e) {
      print('Error fetching user\'s first name: $e');
    }
  }

  Future<void> _addToPlate(
      BuildContext context, String name, double price, String imagePath) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // Check if the item already exists in the Firestore collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('plates')
          .where('name', isEqualTo: name)
          .where('user_id', isEqualTo: user?.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Item already exists, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('The food item is already added to the plate.')),
        );
        return;
      }

      // Convert image to Base64 string from the device's file system
      final bytes = await rootBundle.load(imagePath);
      String base64Image = base64Encode(bytes.buffer.asUint8List());

      final plateItem = {
        'name': name,
        'price': price,
        'image': base64Image,
        'user_id': user?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add the plate item to Firestore
      await FirebaseFirestore.instance.collection('plates').add(plateItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to plate: $name, $price')),
      );
    } catch (e) {
      print('Failed to add to plate: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to plate: $e')),
      );
    }
  }

  var review = [];

  Future<void> _addReview() async {
    if (_commentController.text.isNotEmpty) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        await _fetchUserName();

        final review = {
          'name': _firstName, // Ensure _firstName is updated
          'rating': _currentRating,
          'comment': _commentController.text,
          'image': user?.photoURL ?? 'assets/images/default_user.png',
          'timestamp': FieldValue.serverTimestamp(),
        };

        // Add the review to Firestore
        await FirebaseFirestore.instance.collection('reviews').add(review);

        // Optionally: Clear input fields after successful submission
        setState(() {
          _commentController.clear();
          _currentRating = 5.0; // Reset the rating
        });
        print('Comment: ${_commentController.text}');
      } catch (e) {
        // Handle errors (e.g., show a snackbar)
        print('Failed to add review: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu Page',
          style: GoogleFonts.itim(
            color: Colors.white,
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Plate()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.05,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 4,
                    ),
                  ),
                ),
                child: Text(
                  "Menu",
                  style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: screenWidth * 0.08, // Rsnsv font
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Whether you’re in for a quick bite between classes or a relaxed meal with friends, our menu brings you everything from the comforting classics to bold, modern flavours.",
                style: content.copyWith(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF9C51B),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Text(
                      "Trending Foods",
                      style: GoogleFonts.itim(
                        color: const Color(0xBF000000),
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                color: const Color(0xFFE1CFCF),
                child: Column(
                  children: [
                    Stack(
                      fit: StackFit.loose,
                      children: [
                        Image.asset(
                          "assets/images/foo.png",
                          width: screenWidth * 0.9,
                        ),
                        Positioned(
                          top: screenHeight * 0.03,
                          right: screenWidth * 0.05,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: Text(
                              "Fasting",
                              style: GoogleFonts.itim(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.04),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black.withOpacity(0.4),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              "Penne Arrabbiata",
                              style: GoogleFonts.itim(
                                color: Colors.black,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Image.asset(
                          "assets/images/star.png",
                          width: screenWidth * 0.07,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.04),
                      child: Text(
                        "pasta in a spicy tomato sauce. it’s perfect for those who love a little spice in their life!",
                        style: content.copyWith(fontSize: screenWidth * 0.04),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "70 Birr",
                      style: GoogleFonts.itim(
                        color: Colors.black,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          _addToPlate(context, "Penne Arrabbiata", 70,
                              "assets/images/foo.png");
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          backgroundColor: const Color(0xFFF9C51B),
                          fixedSize:
                              Size(screenWidth * 0.5, screenHeight * 0.07),
                        ),
                        child: Text(
                          "Add to Plate",
                          style: GoogleFonts.itim(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _Header(deviceSize: deviceSize),
              SizedBox(height: deviceSize.height * 0.02),
              _PriceTag(deviceSize: deviceSize),
              SizedBox(height: deviceSize.height * 0.02),
              _Description(deviceSize: deviceSize),
              SizedBox(height: deviceSize.height * 0.03),
              _IngredientsSection(deviceSize: deviceSize),
              SizedBox(height: deviceSize.height * 0.04),
              _AddToPlateButton(deviceSize: deviceSize),
              SizedBox(height: deviceSize.height * 0.04),
              _RatingsSection(),
              const SizedBox(height: 20),
              Text(
                "Reviews",
                style:
                    GoogleFonts.itim(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _AddReviewSection(
                commentController: _commentController,
                currentRating: _currentRating,
                onRatingChanged: (value) {
                  setState(() {
                    _currentRating = value;
                  });
                },
                onSubmit: _addReview,
              ),
              const SizedBox(height: 20),
              _ReviewList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.deviceSize});
  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "Spicy Garlic Shrimp Bowl",
            textAlign: TextAlign.center,
            style: GoogleFonts.itim(
              color: Colors.black,
              fontSize: deviceSize.width * 0.08,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: deviceSize.height * 0.03),
        Center(
          child: Image.asset(
            "assets/images/detail.png",
            height: deviceSize.height * 0.25,
            width: deviceSize.width * 0.8,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.deviceSize});
  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(
          "assets/images/currency.png",
          height: deviceSize.height * 0.03,
          width: deviceSize.height * 0.03,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        Text(
          "150 Birr    ",
          style: GoogleFonts.itim(
            color: Colors.black,
            fontSize: deviceSize.width * 0.06,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.deviceSize});
  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      "A vibrant and flavourful shrimp bowl tossed in our special spicy garlic sauce.",
      style: GoogleFonts.itim(
        color: Colors.black,
        fontSize: deviceSize.width * 0.05,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _IngredientsSection extends StatelessWidget {
  const _IngredientsSection({required this.deviceSize});
  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ingredients",
          style: GoogleFonts.itim(
            color: Colors.black,
            fontSize: deviceSize.width * 0.07,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: deviceSize.height * 0.01),
        Text(
          "Shrimp, garlic, chili flakes, jasmine rice, bell peppers, onions, cilantro, lime.\nAllergens: Shellfish",
          style: GoogleFonts.itim(
            color: Colors.black,
            fontSize: deviceSize.width * 0.05,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _AddToPlateButton extends StatelessWidget {
  const _AddToPlateButton({required this.deviceSize});
  final Size deviceSize;

  Future<void> _addToPlate(
      BuildContext context, String name, double price, String imagePath) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // Check if the item already exists in the Firestore collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('plates')
          .where('name', isEqualTo: name)
          .where('user_id', isEqualTo: user?.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Item already exists, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('The food item is already added to the plate.')),
        );
        return;
      }

      // Convert image to Base64 string from the device's file system
      final bytes = await rootBundle.load(imagePath);
      String base64Image = base64Encode(bytes.buffer.asUint8List());

      final plateItem = {
        'name': name,
        'price': price,
        'image': base64Image,
        'user_id': user?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add the plate item to Firestore
      await FirebaseFirestore.instance.collection('plates').add(plateItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to plate: $name, $price')),
      );
    } catch (e) {
      print('Failed to add to plate: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to plate: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _addToPlate(
              context, "Penne Arrabbiata", 70.0, "assets/images/foo.png");
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: const Color(0xFFF9C51B),
          fixedSize: Size(
            deviceSize.width * 0.5,
            deviceSize.height * 0.07,
          ),
        ),
        child: Text(
          "Add to plate",
          style: GoogleFonts.itim(
            color: Colors.white,
            fontSize: deviceSize.width * 0.05,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _RatingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        children: [
          const Text(
            "5.0",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          RatingBarIndicator(
            rating: 5.0,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 24.0,
          ),
          const SizedBox(height: 4),
          const Text(
            "(5  reviews)",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _AddReviewSection extends StatefulWidget {
  const _AddReviewSection({
    required this.commentController,
    required this.currentRating,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final TextEditingController commentController;
  final double currentRating;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onSubmit;

  @override
  State<_AddReviewSection> createState() => _AddReviewSectionState();
}

class _AddReviewSectionState extends State<_AddReviewSection> {
  final FocusNode _commentFocusNode = FocusNode();
  bool _isCommenting = false;

  @override
  void initState() {
    super.initState();

    // Listen for focus changes
    _commentFocusNode.addListener(() {
      setState(() {
        _isCommenting = _commentFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Call the onSubmit callback
    widget.onSubmit();

    // Clear the text field
    // widget.commentController.clear();

    // Reset the focus and commenting state
    _commentFocusNode.unfocus();
    setState(() {
      _isCommenting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/beke.jpg'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: widget.commentController,
                focusNode: _commentFocusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add a comment and review the dish",
                  hintStyle: GoogleFonts.itim(
                    color: Colors.grey,
                    fontSize: deviceSize.width * 0.05,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        RatingBar.builder(
          initialRating: widget.currentRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: widget.onRatingChanged,
        ),
        const SizedBox(height: 10),
        if (_isCommenting) // Show "Replay" button only when commenting
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _handleSubmit, // Handle submission
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: const Color(0xFFF9C51B),
                ),
                child: const Text("Replay"),
              ),
            ],
          ),
      ],
    );
  }
}

class _ReviewList extends StatelessWidget {
  const _ReviewList();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No reviews yet."));
        }

        final reviews = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index].data() as Map<String, dynamic>;

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(review['image']),
              ),
              title: Text(review['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingBarIndicator(
                    rating: review['rating']?.toDouble() ?? 0,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemSize: 16.0,
                  ),
                  Text(review['comment'] ?? ""),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
