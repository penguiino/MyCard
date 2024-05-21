// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:mycard/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class MainPage extends StatelessWidget{
  const MainPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginDemo();
          }
        },
      ),
    );
  }
}
