import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mother/provider/plate_provider.dart';
import 'dart:convert';
import 'package:mother/payment.dart'; // Ensure you have the payment screen

class Plate extends ConsumerWidget {
  const Plate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plateState = ref.watch(plateProvider);
    final plateNotifier = ref.read(plateProvider.notifier);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    TextStyle small = GoogleFonts.itim(
      color: Colors.black,
      fontSize: screenWidth * 0.04,
      fontWeight: FontWeight.w400,
    );
    TextStyle price = GoogleFonts.itim(
      color: Colors.black,
      fontSize: screenWidth * 0.04,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Plate",
          style: GoogleFonts.itim(
            color: Colors.black,
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: plateState.items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: plateState.items.length,
                    itemBuilder: (context, index) {
                      final item = plateState.items[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Item Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(item.image),
                                  width: screenWidth * 0.2,
                                  height: screenWidth * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Item Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: small),
                                    const SizedBox(height: 4),
                                    Text('${item.price} Birr', style: price),
                                  ],
                                ),
                              ),

                              // Counter Buttons
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.orange),
                                    onPressed: () =>
                                        plateNotifier.decrementCounter(index),
                                  ),
                                  Text(
                                    '${plateState.counters[index]}',
                                    style: small,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline,
                                        color: Colors.orange),
                                    onPressed: () =>
                                        plateNotifier.incrementCounter(index),
                                  ),
                                ],
                              ),

                              // Delete Button
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    plateNotifier.removeItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Details",
                        style: GoogleFonts.itim(
                          color: Colors.black,
                          fontSize: screenWidth * 0.056,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Number of Dishes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Type of Dishes:", style: small),
                          Text("${plateState.totalDishes}", style: small),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Total Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Price (Birr):", style: small),
                          Text("${plateState.totalPrice.toStringAsFixed(2)}",
                              style: small),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Proceed to Payment Button
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to CashPayment & pass the total price
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CashPayment(totalPrice: plateState.totalPrice),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                          backgroundColor: const Color(0xFFF9C51B),
                          fixedSize: Size(screenWidth * 0.52, 49),
                        ),
                        child: Text(
                          "Proceed to Payment",
                          style: small,
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
