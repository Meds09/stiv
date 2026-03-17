import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    return await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
  }
}
