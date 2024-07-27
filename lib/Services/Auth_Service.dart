// ignore_for_file: unused_local_variable

import 'package:classinsight/models/SchoolModel.dart';
import 'package:classinsight/models/TeacherModel.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';



class Auth_Service {
  
static FirebaseAuth auth = FirebaseAuth.instance;

static Future<void> loginAdmin(String email, String password, School school) async {

  try {
      print("HEREEE" + school.schoolId);
      if (school.adminEmail == email) {
        print("HWEFBHEBH"+school.schoolId);

        Get.snackbar('Logging In', '',
          backgroundColor: Colors.white, 
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: AppColors.appDarkBlue
          );


        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        Get.offAllNamed('/AdminHome', arguments: school);
        Get.snackbar('Logged in Successfully', "Welcome, Admin - ${school.name}");

        print("Logged IN");
      } else {
        // Email does not match
        Get.snackbar('Login Error', 'Email does not match the admin email for the school');
      }
    
  } on FirebaseAuthException catch (e) {
    // Handle authentication error
    Get.snackbar('Login Error', e.message ?? 'An error occurred');
  } catch (e) {
    // Handle other errors
    Get.snackbar('Error', e.toString());
  }
}


static Future<void> logout(BuildContext context) async {
    try {
      Get.snackbar('Logging out', '',
          backgroundColor: Colors.white, 
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: AppColors.appDarkBlue
          );

      await Future.delayed(Duration(seconds: 2));

      await auth.signOut();

      Get.deleteAll();

      Get.snackbar('Logged out successfully!', '',
          backgroundColor: Colors.white, duration: Duration(seconds: 2));

      Get.offAllNamed("/onBoarding");
    } catch (e) {
      print('Error logging out: $e');
      Get.snackbar('Error logging out', e.toString(),
          backgroundColor: Colors.red, duration: Duration(seconds: 2));
    }
  }


  static Future<void> registerTeacher(String email, String password, String schoolId) async {
    try {

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration Error', e.message ?? 'An error occurred');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  static Future<Teacher?> loginTeacher(String email, String password, String schoolID ) async {

    Teacher? teacher = null;
    try {
      Get.snackbar('Logging In', '',
          backgroundColor: Colors.white, 
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: AppColors.appDarkBlue
          );


      QuerySnapshot schoolSnapshot = await FirebaseFirestore.instance
        .collection('schools')
        .where('SchoolID', isEqualTo: schoolID)
        .get();

    if (schoolSnapshot.docs.isNotEmpty) {
      School school = School.fromSnapshot(schoolSnapshot.docs.first);

      QuerySnapshot teacherSnapshot = await FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolSnapshot.docs.first.id)
          .collection('Teachers')
          .where('Email', isEqualTo: email)
          .get();


      if (teacherSnapshot.docs.isNotEmpty) {
        
      teacher = Teacher.fromJson(teacherSnapshot.docs.first.data() as Map<String, dynamic>);

    }
    }
     else {
      Get.snackbar('Login Failed', 'No teacher found with this email',
          backgroundColor: Colors.red);

      return teacher;    
    }     

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

     final User user = userCredential.user!;


      Get.offAllNamed('/TeacherHome');
      Get.snackbar('Logged in Successfully', "Welcome, ${teacher!.name}");


      return teacher;

    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Error', e.message ?? 'An error occurred');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    return null;
  }



static Future<void> sendPasswordEmail(String teacherEmail, String teacherName, String password) async {
    final smtpServer = gmail(dotenv.env['GOOGLE_EMAIL']!, dotenv.env['GOOGLE_PASSWORD']!);

    final message = Message()
      ..from = Address(dotenv.env['GOOGLE_EMAIL']!, 'Class Insight')
      ..recipients.add(teacherEmail)
      ..subject = 'Login Credentials for Class Insight'
      ..text = 'Hi $teacherName,\n\nWelcome to Class Insight 😀. Please use the following password to log in to your Teacher Dashboard:\n\nPassword: $password\n\nBest Regards,\nClass Insight Team';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }


}