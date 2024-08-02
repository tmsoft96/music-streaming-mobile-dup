import 'package:rally/components/toast.dart';
import 'package:rally/spec/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> googleSignIn() async {
    googleSignOut();
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential).catchError((error) {
      print("error: $error");
      toastContainer(
        text: "$error",
        backgroundColor: RED,
      );
    });
    final User user = authResult.user!;

    // ignore: unnecessary_null_comparison
    if (user != null) {
      final User currentUser = _auth.currentUser!;
      return currentUser;
    } else
      return null;
  }

  Future<void> googleSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
