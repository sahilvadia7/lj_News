import 'package:auth_ui/providers/user_data_provider.dart';
import 'package:auth_ui/screens/auth.dart';
import 'package:auth_ui/screens/email_verification.dart';
import 'package:auth_ui/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GoogleSignIn googleSignIn = GoogleSignIn();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue),
        primaryColor: Colors.lightBlueAccent,
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return snapshot.data!.emailVerified
                ? const HomeScreen()
                : const EmailVerificationScreen();
          }
          return StreamBuilder(
            stream: googleSignIn.signInSilently().asStream(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (snapshot.hasData) {
                return const HomeScreen();
              }
              return const AuthScreen();
            },
          );
        },
      ),
    );
  }
}
