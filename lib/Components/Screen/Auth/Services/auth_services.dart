import 'package:ai_travel_planner/Components/Screen/Auth/Pages/login_page.dart';
import 'package:ai_travel_planner/Components/Screen/Home_Page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../Create_Trip/Pages/Services/database.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentuser => _firebaseAuth.currentUser;
  Stream<User?> get authStatusChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      if (userCredential.user!.emailVerified) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Home_Page.routeName,
              (route) => false,
        );
      } else {
        await userCredential.user?.sendEmailVerification();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Email is not verified")));
        await _firebaseAuth.signOut();
      }
    }
  }


  Future<void> handleGoogleSign(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) return;
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        if (isNewUser) {
          await DatabaseMethods().addProfileToDatabase(
            {
              "name": userCredential.user!.displayName,
              "email": userCredential.user!.email,
              "photoURL": userCredential.user!.photoURL,
            },
            userCredential.user!.uid,
          );
        }
        Navigator.pushNamedAndRemoveUntil(
          context,
          Home_Page.routeName,
              (route) => false,
        );
      }
    } catch (e) {
      print("Error during sign-in: $e");
    }
  }



  Future<void> createUserWithEmailAndPassword(
      {required String email,
        required String password,
        required BuildContext context,
        required Map<String, dynamic> userInfoMap}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    await DatabaseMethods().addProfileToDatabase(
        userInfoMap, FirebaseAuth.instance.currentUser!.uid);

    await userCredential.user?.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully Created,Check Email To verify")));
    await _firebaseAuth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.routeName,
          (route) => false,
    );
  }


}