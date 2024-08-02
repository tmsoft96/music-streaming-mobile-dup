import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rally/spec/properties.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sharePreference.dart';
import 'firebaseProfile.dart';

String? firebaseUserId;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

abstract class BaseAuth {
  Future<String> signIn({@required String email});

  Future<String> signUp({@required String email});

  Future<User> getCurrentUser();

  Future<void> sendVerification();

  Future<bool> isEmailVerified();

  Future<void> signOut();
}

class FireAuth implements BaseAuth {
  FireProfile _firebaseProfile = new FireProfile();

  @override
  Future<User> getCurrentUser() async {
    User user = _firebaseAuth.currentUser!;
    return user;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp({
    @required String? email,
    @required String? password,
  }) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    User user = result.user!;
    return user.uid;
  }

  @override
  Future<String> signIn({
    @required String? email,
    @required String? userId,
    @required String? name,
    @required String? role,
    String password = DEFAULTPASSWORD,
  }) async {
    String? ret = "";
    signOut();
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email!,
        password: password,
      );
      User user = result.user!;
      print("fire out ${user.uid}");
      //add user details to db
      await _firebaseProfile.createAccount(
        email: email,
        firebaseUserId: user.uid,
        userId: userId,
        name: name,
        role: role,
      );
      firebaseUserId = user.uid;
      saveStringShare(key: "firebaseUserId", data: firebaseUserId);
      saveToken();
      return user.uid;
    } on PlatformException catch (error) {
      //create new account if log in successfully
      print(error);
      signUp(email: email, password: password).then((value) {
        signIn(
          email: email,
          userId: userId,
          name: name,
          password: password,
          role: role,
        );
        ret = "login";
      });
    } catch (e) {
      //create new account if log in successfully
      print(e);
      signUp(email: email, password: password).then((value) {
        signIn(
          email: email,
          userId: userId,
          name: name,
          password: password,
          role: role,
        );
        ret = "login";
      });
    }
    return ret!;
  }

  @override
  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser!;
    return user.emailVerified;
  }

  @override
  Future<void> sendVerification() async {
    User user = _firebaseAuth.currentUser!;
    return user.sendEmailVerification();
  }

  @override
  // ignore: override_on_non_overriding_member
  Future getCurrentUserId() async {
    User user = _firebaseAuth.currentUser!;
    return user.uid;
  }

  Future<void> saveToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("firebaseUserId")) {
      firebaseUserId = prefs.getString("firebaseUserId");
      CollectionReference _collection =
          FirebaseFirestore.instance.collection("AllDeviceToken");
      _collection.doc(firebaseUserId).set({
        "id": firebaseUserId,
        "token": fcmToken,
        "createdAt": Timestamp.now(),
        "platform": Platform.operatingSystem,
        "version": VERSIONNUMBER,
      });
    } else {
      print("No firebase Id = log in yet");
    }
  }
}
