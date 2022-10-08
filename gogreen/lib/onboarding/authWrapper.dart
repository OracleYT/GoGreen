import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/navigationWrapper.dart';
import '../home/registrationPage.dart';

// import '../home/navigationWrapper.dart';
// import '../registrationPage.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Something Went Wrong!"),
                );
              } else if (snapshot.hasData) {
                return NavigationWrapper();
              } else {
                return RegstrationPage();
              }
            }),
      );
}
