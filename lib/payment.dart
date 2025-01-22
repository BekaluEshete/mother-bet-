import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CashPayment extends StatefulWidget {
  final double totalPrice;

  const CashPayment({super.key, required this.totalPrice});

  @override
  State<CashPayment> createState() => _CashPaymentState();
}

class _CashPaymentState extends State<CashPayment> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Future<void> processChapaPayment() async {
    String chapaApiKey =
        "CHAPUBK_TEST-vl2wfSkqujcEcYDK6NFQSc2UQ1b9aL5r"; // Replace with your Chapa API Key
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount < widget.totalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Insufficient amount! Enter at least ${widget.totalPrice} Birr"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url = Uri.parse("https://api.chapa.co/v1/transaction/initialize");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $chapaApiKey",
    };

    final body = jsonEncode({
      "amount": amount.toString(),
      "currency": "ETB",
      "email": "${_userIdController.text}@gmail.com", // Dummy email
      "first_name": "User",
      "last_name": "Payment",
      "tx_ref": "TX-${DateTime.now().millisecondsSinceEpoch}",
      "callback_url": "https://beke.site",
      "return_url": "https://bekelu.com/return",
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String checkoutUrl = responseData["data"]["checkout_url"];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Redirecting to Chapa payment..."),
          backgroundColor: Colors.green,
        ),
      );

      // Open the payment URL in a WebView or browser
      // (You can use url_launcher package)
      print("Payment URL: $checkoutUrl"); // Debugging
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment failed! Please try again."),
          backgroundColor: Colors.red,
        ),
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
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 18),
        child: Column(
          children: [
            Row(children: [Text("Cash Payment", style: textStyle)]),
            const SizedBox(height: 20),
            Row(children: [Text("User Id", style: textStyle)]),
            const SizedBox(height: 8),
            _buildTextField(
              width: media.width * 0.7,
              controller: _userIdController,
              hintText: "Enter user Id",
            ),
            const SizedBox(height: 20),
            Row(children: [Text("Amount", style: textStyle)]),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildTextField(
                  width: media.width * 0.5,
                  controller: _amountController,
                  hintText: "Enter amount",
                ),
                SizedBox(width: media.width * 0.05),
                ElevatedButton(
                  onPressed: processChapaPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Pay",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hintText,
  int maxLines = 1,
  required var width,
}) {
  return Container(
    width: width,
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
