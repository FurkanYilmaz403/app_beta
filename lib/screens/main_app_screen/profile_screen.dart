import 'package:app_beta/services/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile Page"),
            ElevatedButton(
              onPressed: () {
                FirebaseAuthProvider(FirebaseAuth.instance).signOut(context);
              },
              child: const Text("Hesaptan çık"),
            )
          ],
        ),
      ),
    );
  }
}
