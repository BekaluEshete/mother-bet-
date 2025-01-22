import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mother/auth/regst.dart';
import 'package:mother/menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    TextStyle tilte = GoogleFonts.itim(
      color: Colors.black,
      fontSize: screenWidth * 0.1,
      fontWeight: FontWeight.w400,
      height: 1.2, // Adjust line spacing if needed
    );
    TextStyle content = GoogleFonts.itim(
      color: const Color((0xBF000000)),
      fontSize: screenWidth * 0.04,
      fontWeight: FontWeight.w400,
    );
    TextStyle subtitle = GoogleFonts.itim(
      color: Colors.black,
      fontSize: screenWidth * 0.045,
      fontWeight: FontWeight.w500,
    );
    final checkIcon = Image.asset(
      "assets/images/check.png",
      width: screenWidth * 0.1,
      height: screenWidth * 0.1,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // Dynamic horizontal padding
            vertical: screenHeight * 0.04,
          ),
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Good Food,\n",
                      style: tilte,
                    ),
                    TextSpan(
                      text: "Great Vibes,\n",
                      style: GoogleFonts.itim(
                        color: const Color(0xFFFF5733),
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: "Perfect for your \n",
                      style: tilte,
                    ),
                    TextSpan(
                      text: "Campus life!",
                      style: tilte,
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: screenHeight * 0.02),
              Image.asset(
                "assets/images/home.png",
                fit: BoxFit.cover,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text("Where bold flavours meet unforgettable campus moments!",
                  style: GoogleFonts.merriweather(
                    fontStyle: FontStyle.italic,
                    color: const Color((0xBF000000)),
                    fontSize: screenWidth * 0.04,
                  )),
              SizedBox(height: screenWidth * 0.02),
              Row(children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUpView(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    backgroundColor: const Color(0xFFF9C51B),
                    fixedSize: Size(screenWidth * 0.45,
                        screenHeight * 0.07), // Set width and height
                  ),
                  child: Text(
                    "Start Ordering",
                    style: GoogleFonts.itim(
                      color: Colors.black,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    fixedSize: Size(screenWidth * 0.35, screenHeight * 0.07),
                    side: const BorderSide(
                        color: Color(0xFFF9C51B),
                        width: 2), // Set border color and width
                  ),
                  child: Text(
                    "About Us",
                    style: GoogleFonts.itim(
                      color: Colors.black,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
              SizedBox(height: screenHeight * 0.04),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.02,
                ), // Adjust padding as needed
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 3,
                      color: Color(0xFFFFD70F), // Top border color
                    ),
                    bottom: BorderSide(
                      width: 3,
                      color: Color(0xFFFFD70F), // Bottom border color
                    ),
                  ),
                ),
                transform: Matrix4.identity()
                  ..rotateZ(-3 * 3.141592653589793 / 180), // Rotate upwards
                transformAlignment:
                    Alignment.center, // Rotate around the center
                child: Text(
                  'Dishes We Provide ',
                  style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Image.asset(
                "assets/images/menu.png",
              ),
              Text(
                "Our menu caters to both fasting and non-fasting preferences, with easy filters to customize your search. Sort dishes to discover popular favourites or explore something new. Save top picks to your favourites for quick access anytime!",
                style: content,
              ),
              SizedBox(height: screenHeight * 0.02),

              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.4), // opacity
                          width: 2, // Thickness of 2
                        ),
                      ),
                    ),
                    child: Text(
                      "Non-Fasting Food",
                      style: subtitle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              Text(
                "Each dish is crafted to be light, nutritious, and flavourful, offering a satisfying meal during fasting periods. We ensure that our fasting meals are both wholesome and delicious.",
                style: content,
              ),
              Image.asset(
                "assets/images/non-fast.png",
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.4), // opacity
                          width: 2, // Thickness of 2
                        ),
                      ),
                    ),
                    child: Text(
                      "Fasting Food",
                      style: subtitle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              Text(
                "At our restaurant, we carefully prepare non-fasting foods using the finest meats, dairy, and seasonings. ",
                style: content,
              ),
              SizedBox(height: screenHeight * 0.04),

              Image.asset(
                "assets/images/fast.png",
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.02,
                ), // Adjust padding as needed
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 3,
                      color: Color(0xFFFFD70F), // Top border color
                    ),
                    bottom: BorderSide(
                      width: 3,
                      color: Color(0xFFFFD70F), // Bottom border color
                    ),
                  ),
                ),
                transform: Matrix4.identity()
                  ..rotateZ(-3 * 3.141592653589793 / 180), // Rotate upwards
                transformAlignment:
                    Alignment.center, // Rotate around the center
                child: Text(
                  'Payment and Subscriptions ',
                  style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.045,
              ),
              Image.asset(
                "assets/images/pay-sub.png",
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.4), // opacity
                          width: 2, // Thickness of 2
                        ),
                      ),
                    ),
                    child: Text(
                      "Payment Methods",
                      style: subtitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Our restaurant makes payments easy and convenient with options tailored to campus students. You can pay quickly through Mpesa, Telebirr, or direct bank transfer, allowing you to focus more on enjoying your meal and less on payment hassles. Choose the method that suits you best, and enjoy a seamless experience every time you order with us!",
                style: content,
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset("assets/images/pay-method.png"),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.4), // opacity
                          width: 2, // Thickness of 2
                        ),
                      ),
                    ),
                    child: Text(
                      "Subscription Meal Services",
                      style: subtitle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                "Our Subscription Meal Service offers a flexible dining experience tailored to your schedule! Once subscribed, ",
                style: content,
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  checkIcon,
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: "Easy Meal Planning: ", style: subtitle),
                      TextSpan(
                          text:
                              "Choose your meals and schedule them in advance according to your routine.",
                          style: content)
                    ])),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                children: [
                  checkIcon,
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: "Seamless Payment: ", style: subtitle),
                      TextSpan(
                          text:
                              "No need to pay every time meal costs are automatically deducted from your pre-paid subscription deposit.",
                          style: content)
                    ])),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                children: [
                  checkIcon,
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Perfect for Busy Students: ", style: subtitle),
                      TextSpan(
                          text:
                              "Enjoy delicious, nutritious meals without interrupting your schedule.",
                          style: content)
                    ])),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                children: [
                  checkIcon,
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: "Automatic Ordering: ", style: subtitle),
                      TextSpan(
                          text:
                              "Set meal times, and our system will place your order right on time, hassle-free.",
                          style: content)
                    ])),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.02,
                ), // Adjust padding as needed
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 3,
                      color: Color(0xFFFFD70F),
                    ),
                    bottom: BorderSide(
                      width: 3,
                      color: Color(0xFFFFD70F), // Bottom border color
                    ),
                  ),
                ),
                transform: Matrix4.identity()
                  ..rotateZ(-3 * 3.141592653589793 / 180), // Rotate upwards
                transformAlignment:
                    Alignment.center, // Rotate around the center
                child: Text(
                  'Feedbacks and Rating ',
                  style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Image.asset("assets/images/feedback.png"),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                "We value your feedback and want to hear about your experience! Our platform makes it easy for you to",
                style: content,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                children: [
                  checkIcon,
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  Text(
                    "share your thoughts on our services",
                    style: content,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                children: [
                  checkIcon,
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  Text(
                    "rate each dish you enjoy",
                    style: content,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                "Whether you loved a meal or have suggestions for improvement, simply leave a rating or send us feedback directly through our website. Your input helps us continue improving and delivering meals you’ll love, tailored just for you!",
                style: content,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),

              // Footer widget added after enough content
              Container(
                width: double.infinity,
                color: const Color(0xFFFF3D14),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/locat.png",
                          height: screenHeight * 0.02,
                        ),
                        SizedBox(width: screenWidth * 0.012),
                        Text(
                          "Bahir Dar University, Bahir Dar, Ethiopia",
                          style: content,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/mail.png",
                          height: screenHeight * 0.02,
                          color: Colors.white,
                        ),
                        SizedBox(width: screenWidth * 0.012),
                        Text(
                          "Mother_Bet@gmail.com",
                          style: content,
                        ),
                      ],
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
}
