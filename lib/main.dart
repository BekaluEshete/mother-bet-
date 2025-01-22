import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mother/addnew.dart';
import 'package:mother/auth/regst.dart';
import 'package:mother/detail.dart';
import 'package:mother/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:mother/menu.dart';
import 'package:mother/admins_screen/dashboard.dart';
import 'package:mother/navigation/edit.dart';
import 'package:mother/navigation/main_navigation.dart';
import 'package:mother/navigation/summary.dart';
import 'package:mother/payment.dart';
import 'package:mother/plate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the app is running on the web and initialize Firebase accordingly
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyASdyGXfy8DzyGlJ_Cw9md2EFJMODoy2o4",
        appId: "1:587120013068:web:3a07fd764ed334e48be329",
        messagingSenderId: "587120013068",
        projectId: "mother-bet",
      ),
    );
  } else {
    await Firebase.initializeApp(); // For mobile platforms
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mother-bet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:

          //const CashPayment(),
          //const DetailScreen(),
          // const NewDish(),
          //EditScreen(),
          // const DashboardScreen(),
          // const Menu(),
          //const MainNavigation(),
          //const NewDish()
          //  const Plate(),
          const HomePage(),
      //const SignUpView(),
      //SummaryScreen()

      ///
      ///
    );
  }
}
