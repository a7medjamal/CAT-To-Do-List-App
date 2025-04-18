import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository_interface.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<void> login({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUp({required String email, required String password}) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut(); // Optional: in case the user signed in with Google
    await _auth.signOut();
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Google Sign-In failed: ${e.toString()}');
    }
  }
}
