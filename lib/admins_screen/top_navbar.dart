import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 190, 225, 32),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      title: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: GoogleFonts.lato(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () {
              // Add your onPressed action here
            },
          ),
          SizedBox(width: screenWidth * 0.04),
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/images/beke.jpg'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
