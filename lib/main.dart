import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/firebase_options.dart';
import 'package:app_beta/screens/auth_screen/sign_screen.dart';
import 'package:app_beta/screens/main_app_screen/screen_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MainScreen(),
  );
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Ubuntu",
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> user) {
          if (user.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: warningColor,
              ),
            );
          } else if (user.hasData &&
              user.data?.email != null &&
              user.data!.email!.isNotEmpty) {
            return const ScreenLayout();
          } else {
            return SignScreen();
          }
        },
      ),
    );
  }
}
