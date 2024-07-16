// ignore_for_file: prefer_const_constructors

import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/Widgets/CustomBlueButton.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:classinsight/screens/adminSide/ManageStudents.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:classinsight/utils/AppColors.dart';

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
  Future<List<String>>? classesList;

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
  void initState() {
    super.initState();
    classesList = Database_Service.fetchAllClasses('buwF2J4lkLCdIVrHfgkP');
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 350) {
      addStdFontSize = 14;
      headingFontSize = 25;
    }
    if (screenWidth < 300) {
      addStdFontSize = 14;
      headingFontSize = 23;
    }
    if (screenWidth < 250) {
      addStdFontSize = 11;
      headingFontSize = 20;
    }
    if (screenWidth < 230) {
      addStdFontSize = 8;
      headingFontSize = 17;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.appLightBlue,
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
                      backgroundColor: AppColors.appLightBlue,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageStudents()),
                          );
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
                                          color: AppColors.appLightBlue,
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
                              padding: EdgeInsets.fromLTRB(30, 0, 10, 5),
                              child: Text(
                                'Class',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15, // Adjust as needed
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 15),
                              child: FutureBuilder<List<String>>(
                                future: classesList,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Center(
                                        child: Text('No classes found'));
                                  } else {
                                    List<String> classes = snapshot.data!;
                                    if (!classes.contains(selectedClass)) {
                                      selectedClass = classes[0];
                                    }
                                    return DropdownButtonFormField<String>(
                                      value: selectedClass,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.appLightBlue,
                                              width: 2.0),
                                        ),
                                      ),
                                      items: classes.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedClass = newValue!;
                                        });
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                              child: CustomBlueButton(
                                buttonText: 'Add',
                                onPressed: () async {
                                  if (_validateInputs()) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppColors.appLightBlue,
                                            ),
                                          ),
                                        );
                                      },
                                    );

                                    Database_Service databaseService =
                                        Database_Service();

                                    final student = Student(
                                      name: nameController.text,
                                      gender: selectedGender,
                                      bFormChallanId:
                                          bForm_challanIdController.text,
                                      fatherName: fatherNameController.text,
                                      fatherPhoneNo:
                                          fatherPhoneNoController.text,
                                      fatherCNIC: fatherCNICController.text,
                                      studentRollNo:
                                          studentRollNoController.text,
                                      studentID:
                                          '', 
                                      classSection: selectedClass,
                                      resultMap: {}, // No need to initialize resultMap here
                                    );

                                    await databaseService.saveStudent(
                                      'buwF2J4lkLCdIVrHfgkP', 
                                      selectedClass,
                                      student,
                                    );

                                    Navigator.of(context)
                                        .pop(); // Hide the progress indicator
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ManageStudents(),
                                      ),
                                    );
                                  }
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

  bool _validateInputs() {
    setState(() {
      nameValid = nameController.text.isNotEmpty;
      genderValid = selectedGender.isNotEmpty;
      bForm_challanIdValid = bForm_challanIdController.text.isNotEmpty;
      fatherNameValid = fatherNameController.text.isNotEmpty;
      fatherPhoneNoValid = fatherPhoneNoController.text.isNotEmpty;
      fatherCNICValid = fatherCNICController.text.isNotEmpty;
      studentRollNoValid = studentRollNoController.text.isNotEmpty;
      selectedClassValid = selectedClass.isNotEmpty;
    });

    return nameValid &&
        genderValid &&
        bForm_challanIdValid &&
        fatherNameValid &&
        fatherPhoneNoValid &&
        fatherCNICValid &&
        studentRollNoValid &&
        selectedClassValid;
  }
}
