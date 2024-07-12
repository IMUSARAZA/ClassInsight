// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:classinsight/Const/AppColors.dart';
import 'package:classinsight/Model/StudentModel.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(EditStudent());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class EditStudent extends StatefulWidget {
  const EditStudent({Key? key}) : super(key: key);

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  String studentID = ''; // Initialize with an empty string
  late Future<Student?> student;

  @override
  void initState() {
    super.initState();
    // Assuming you have a method to fetch a student by ID
    student = Database_Service.getStudentByID('School1', studentID);
  }

  double editStdFontSize = 16;
  double headingFontSize = 33;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 350) {
      editStdFontSize = 14;
      headingFontSize = 27;
    }
    if (screenWidth < 300) {
      editStdFontSize = 14;
      headingFontSize = 24;
    }
    if (screenWidth < 250) {
      editStdFontSize = 11;
      headingFontSize = 20;
    }
    if (screenWidth < 230) {
      editStdFontSize = 8;
      headingFontSize = 15;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Appcolors.appLightBlue,
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: screenHeight * 0.10,
                    width: screenWidth,
                    child: AppBar(
                      backgroundColor: Appcolors.appLightBlue,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      title: Center(
                        child: Text(
                          'Edit Student',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: editStdFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        Container(
                          width: 48.0, // Adjust as needed
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.05 * screenHeight,
                    width: screenWidth,
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Edit Student',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: headingFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: FutureBuilder<Student?>(
                        future: student,
                        builder: (BuildContext context, AsyncSnapshot<Student?> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Appcolors.appLightBlue,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData || snapshot.data == null) {
                            return Center(
                              child: Text('Student not found'),
                            );
                          } else {
                            // Data fetched successfully
                            Student student = snapshot.data!;
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Add your form fields here to edit the student information
                                    Text('Name: ${student.name}'),
                                    Text('Gender: ${student.gender}'),
                                    // Add more fields as necessary
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
