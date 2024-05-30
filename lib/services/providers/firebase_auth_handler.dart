
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthProvider extends ChangeNotifier {

  static FirebaseAuth firebaseAuth=FirebaseAuth.instance;


  Future<UserCredential?> signInWithGoogle() async {
    try {

      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );


      return await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');


      return null;
    }
  }


  Future<void> signOut()async{
   await firebaseAuth.signOut();
  }

}
