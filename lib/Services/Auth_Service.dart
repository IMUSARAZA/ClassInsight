import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class Auth_Service {
  static Future<void> login(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar('LoggedIn',"Welcome, Admin",backgroundColor:Colors.white);
      Get.offNamed('/AdminHome');
      print("Logged IN");
    } on FirebaseAuthException catch (e) {
      // Handle authentication error
      Get.snackbar('Login Error', e.message ?? 'An error occurred');
    }
  }
}