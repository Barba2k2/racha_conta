import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireauthProvider with ChangeNotifier {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  static String? getCurrentUserId() {
    final User? user = getCurrentUser();
    if (user != null) {
      return user.uid;
    }
    return null;
  }
}