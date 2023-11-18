import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<User?> signInWithEmailPassword(
      String email, String password) async {
    customToast(string) async {
      await Fluttertoast.showToast(
          msg: string,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        customToast("No user found for that email.");
        print('No user found for that email.');
        return null;
      } else if (e.code == 'wrong-password') {
        customToast("Wrong password provided for that user.");
        print('Wrong password provided for that user.');
        return null;
      }
    }
  }

  static Future<User?> createUserWithEmailPassword(
      String email, String password) async {
    customToast(string) async {
      await Fluttertoast.showToast(
          msg: string,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        customToast("The password provided is too weak.");
        print('The password provided is too weak.');
        return null;
      } else if (e.code == 'email-already-in-use') {
        customToast("The account already exists for that email.");
        print('The account already exists for that email.');
        return null;
      }
    }
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
