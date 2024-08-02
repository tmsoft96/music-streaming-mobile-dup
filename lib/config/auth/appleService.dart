import 'package:firebase_auth/firebase_auth.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/spec/colors.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AppleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> appleSignIn() async {
    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleUser = result.credential!;
        final OAuthProvider authProvider = new OAuthProvider("apple.com");

        final AuthCredential credential = authProvider.credential(
          idToken: String.fromCharCodes(appleUser.identityToken!),
          accessToken: String.fromCharCodes(appleUser.authorizationCode!),
        );

        UserCredential user =
            await _auth.signInWithCredential(credential).catchError((error) {
          print("error: $error");
          toastContainer(
            text: "$error",
            backgroundColor: RED,
          );
        });
        print("firebase : $user");
        print("apple: ${appleUser.fullName!.familyName!}");
        return {"firebase": user, "apple": appleUser};
      case AuthorizationStatus.error:
        return null;
      case AuthorizationStatus.cancelled:
        return null;
    }
  }
}
