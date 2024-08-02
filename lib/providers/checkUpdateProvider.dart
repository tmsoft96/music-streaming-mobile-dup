import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rally/config/checkConnection.dart';
import 'package:rally/config/deleteCache.dart';
import 'package:rally/config/firebase/firebaseAuth.dart';
import 'package:rally/config/locator.dart';
import 'package:rally/config/sharePreference.dart';
import 'package:rally/routes/routeName.dart';
import 'package:rally/services/navigationServices.dart';
import 'package:rally/spec/properties.dart';

Future<void> checkUpdate() async {
  final NavigationService _navigationService = locator<NavigationService>();

  checkConnection().then((connection) async {
    if (connection) {
      DocumentReference _collection =
          FirebaseFirestore.instance.collection("Other").doc("update");
      _collection.snapshots().listen((DocumentSnapshot snapshot) async {
        Map<String, dynamic> values = snapshot.data() as Map<String, dynamic>;
        print("values $values");
        int buildNumber = values["buildNumber"];
        bool userLogout = values["userLogout"];

        if (BUILDNUMBER >= buildNumber) {
          print("current version up to date with build: $buildNumber");
        } else {
          if (userLogout) {
            await deleteCache().whenComplete(() {
              saveBoolShare(key: "auth", data: false);
              FireAuth _fireAuth = new FireAuth();
              _fireAuth.signOut().then((value) {
                saveBoolShare(key: "auth", data: false);
              });
            });
          }
          _navigationService.navigateTo(UpdateViewRoute, arguments: values);
        }
      });
    } else {
      print("No internet connection");
    }
  });
}
