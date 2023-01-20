import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory/src/app.dart';

// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.leanBack,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory',
      theme: ThemeData(
        primarySwatch: UiColors.kToWhite,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Text(
            'Inventory',
            style: GoogleFonts.montserrat(
                textStyle: Theme.of(context).textTheme.headline4, fontSize: 40, fontWeight: FontWeight.w400, color: UiColors.white),
          ),
          SizedBox(width: 300, child: Lottie.asset('assets/logo_animated.json')),
          // se puede usar imagenes
        ],
      ),
      backgroundColor: kBackgroundColor,
      nextScreen: const App(),
      splashIconSize: 400,
      duration: 4000,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}
