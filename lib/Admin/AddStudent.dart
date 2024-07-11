// ignore_for_file: prefer_const_constructors

import 'package:classinsight/Model/StudentModel.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/Widgets/CustomBlueButton.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:classinsight/Const/AppColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(AddStudent());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bForm_challanIdController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherPhoneNoController = TextEditingController();
  TextEditingController fatherCNICController = TextEditingController();
  TextEditingController studentRollNoController = TextEditingController();

  bool nameValid = true;
  bool genderValid = true;
  bool bForm_challanIdValid = true;
  bool fatherNameValid = true;
  bool fatherPhoneNoValid = true;
  bool fatherCNICValid = true;
  bool studentRollNoValid = true;
  bool selectedClassValid = true;

  String selectedGender = '';
  String selectedClass = '';

  double addStdFontSize = 16;
  double headingFontSize = 33;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 350) {
      addStdFontSize = 14;
      headingFontSize = 27;
    }
    if (screenWidth < 300) {
      addStdFontSize = 14;
      headingFontSize = 24;
    }
    if (screenWidth < 250) {
      addStdFontSize = 11;
      headingFontSize = 20;
    }
    if (screenWidth < 230) {
      addStdFontSize = 8;
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
                          'Add Student',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: addStdFontSize,
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
                      'Add New Student',
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                              child: CustomTextField(
                                controller: nameController,
                                hintText: 'Name',
                                labelText: 'Name',
                                isValid: nameValid,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.white,
                                ),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintText: "Select your gender",
                                    labelText: "Gender",
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Appcolors.appLightBlue,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                  ),
                                  value: selectedGender.isEmpty
                                      ? null
                                      : selectedGender,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedGender = newValue!;
                                    });
                                  },
                                  items: <String>['Male', 'Female', 'Other']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: bForm_challanIdController,
                                hintText: 'B-Form/Challan ID',
                                labelText: 'B-Form/Challan ID',
                                isValid: bForm_challanIdValid,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: fatherNameController,
                                hintText: "Father's name",
                                labelText: "Father's name",
                                isValid: fatherNameValid,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: fatherPhoneNoController,
                                hintText: "Father's phone no.",
                                labelText: "Father's phone no.",
                                isValid: fatherPhoneNoValid,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: fatherCNICController,
                                hintText: "Father's CNIC",
                                labelText: "Father's CNIC",
                                isValid: fatherCNICValid,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: studentRollNoController,
                                hintText: "Student's Roll no.",
                                labelText: "Student's Roll no.",
                                isValid: studentRollNoValid,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.white,
                                ),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintText: "Select section of student",
                                    labelText: "Section",
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(
                                          color: Appcolors.appLightBlue,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                  ),
                                  value: selectedClass.isEmpty
                                      ? null
                                      : selectedClass,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedClass = newValue!;
                                    });
                                  },
                                  items: <String>['2A', '3B', '4D']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                              child: CustomBlueButton(
                                buttonText: 'Add',
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Appcolors.appLightBlue),
                                        ),
                                      );
                                    },
                                  );

                                  print('Button pressed!');
                                  print(nameController.text);
                                  print(selectedGender);
                                  final student = Student(
                                    name: nameController.text,
                                    gender: selectedGender,
                                    bForm_challanId:
                                        bForm_challanIdController.text,
                                    fatherName: fatherNameController.text,
                                    fatherPhoneNo: fatherPhoneNoController.text,
                                    fatherCNIC: fatherCNICController.text,
                                    studentRollNo: studentRollNoController.text,
                                    studentID: '', // Set by Database_Service
                                    classSection: selectedClass,
                                  );
                                  await Database_Service.saveStudent(
                                      'School1', student);

                                  Navigator.of(context)
                                      .pop(); // Hide the progress indicator
                                },
                              ),
                            ),
                          ],
                        ),
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
