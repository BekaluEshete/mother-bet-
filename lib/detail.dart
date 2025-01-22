import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mother/addnew.dart';
import 'package:mother/plate.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Plate(),
          ));
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
