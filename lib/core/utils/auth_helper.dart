import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  static String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user signed in");
    }
    return user.uid;
  }
}
