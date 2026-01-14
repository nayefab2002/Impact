import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<OAuthCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
  await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  return credential;
}
Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    ) async {
  try {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  } on FirebaseAuthException catch (e) {
    // Handle errors
    //debugPrint('Sign up error: ${e.code} - ${e.message}');
    return null;
  }
}
