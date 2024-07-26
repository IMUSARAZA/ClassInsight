// lib/controllers/add_student_controller.dart
// ignore_for_file: prefer_const_constructors

import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:get/get.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:flutter/material.dart';
import 'package:classinsight/Widgets/CustomBlueButton.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/screens/adminSide/ManageStudents.dart';
import 'package:classinsight/utils/AppColors.dart';

class AddStudentController extends GetxController {
  // TextEditingController instances
  final nameController = TextEditingController();
  final bFormChallanIdController = TextEditingController();
  final fatherNameController = TextEditingController();
  final fatherPhoneNoController = TextEditingController();
  final fatherCNICController = TextEditingController();
  final studentRollNoController = TextEditingController();

  final AdminHomeController school = Get.find();

  // Observables for validation
  var nameValid = true.obs;
  var genderValid = true.obs;
  var bFormChallanIdValid = true.obs;
  var fatherNameValid = true.obs;
  var fatherPhoneNoValid = true.obs;
  var fatherCNICValid = true.obs;
  var studentRollNoValid = true.obs;
  var selectedClassValid = true.obs;

  // Observable for selected values
  var selectedGender = ''.obs;
  var selectedClass = ''.obs;

  // Fetch classes from the database
  Future<List<String>> fetchClasses() async {
    return await Database_Service.fetchAllClasses(school.schoolId.value);
  }

  bool validateInputs() {
    // Regular expressions for validation
    RegExp numeric13Digits = RegExp(r'^\d{13}$');
    RegExp numeric11Digits = RegExp(r'^\d{11}$');

    // Validate each field
    nameValid.value = nameController.text.isNotEmpty;
    genderValid.value = selectedGender.isNotEmpty;
    bFormChallanIdValid.value = bFormChallanIdController.text.isNotEmpty;
    if (fatherPhoneNoController.text.isNotEmpty) {
      fatherPhoneNoValid.value =
          numeric11Digits.hasMatch(fatherPhoneNoController.text);
    } else {
      fatherPhoneNoValid.value = true;
    }
    if (fatherCNICController.text.isNotEmpty) {
      fatherCNICValid.value =
          numeric13Digits.hasMatch(fatherCNICController.text);
    } else {
      fatherCNICValid.value = true;
    }
    studentRollNoValid.value = studentRollNoController.text.isNotEmpty;
    selectedClassValid.value = selectedClass.isNotEmpty;

    // Return overall validation status
    return nameValid.value &&
        genderValid.value &&
        bFormChallanIdValid.value &&
        fatherNameValid.value &&
        fatherPhoneNoValid.value &&
        fatherCNICValid.value &&
        studentRollNoValid.value &&
        selectedClassValid.value;
  }

  Future<void> addStudent() async {
    if (validateInputs()) {
      // Show loading dialog
      Get.dialog(
        Center(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appLightBlue),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Adding student...',
                  style: TextStyle(
                    color: AppColors.appLightBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Create a new Student object
      final student = Student(
        name: nameController.text,
        gender: selectedGender.value,
        bFormChallanId: bFormChallanIdController.text,
        fatherName: fatherNameController.text,
        fatherPhoneNo: fatherPhoneNoController.text,
        fatherCNIC: fatherCNICController.text,
        studentRollNo: studentRollNoController.text,
        studentID: '', // This will be assigned by Firestore
        classSection: selectedClass.value,
        feeStatus: '-',
        feeStartDate: '-',
        feeEndDate: '-',
        resultMap: {}, // Initialize resultMap here as an empty map
      );

      // Call the database service to save the student
      Database_Service databaseService = Database_Service();
      await databaseService.saveStudent(
        school.schoolId.value, // Replace with your actual school ID
        selectedClass.value, // Pass selected class section
        student, // Pass the student object
      );

      Get.back(); // Hide the progress indicator
      Get.off(() => ManageStudents());
    }
  }
}

class AddStudent extends StatelessWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddStudentController controller = Get.put(AddStudentController());

    return Scaffold(
      backgroundColor: AppColors.appLightBlue,
      body: Obx(() {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;

        double addStdFontSize = 16;
        double headingFontSize = 33;

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

        return SingleChildScrollView(
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
                          Get.off(() => ManageStudents());
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
                                controller: controller.nameController,
                                hintText: 'Name',
                                labelText: 'Name',
                                isValid: controller.nameValid.value,
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
                                  value: controller.selectedGender.value.isEmpty
                                      ? null
                                      : controller.selectedGender.value,
                                  onChanged: (newValue) {
                                    controller.selectedGender.value = newValue!;
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
                                controller: controller.bFormChallanIdController,
                                hintText: 'B-Form/Challan ID',
                                labelText: 'B-Form/Challan ID',
                                isValid: controller.bFormChallanIdValid.value,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: controller.fatherNameController,
                                hintText: "Father/Guardian's name",
                                labelText: "Father/Guardian's name",
                                isValid: controller.fatherNameValid.value,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: controller.fatherPhoneNoController,
                                hintText: "03xxxxxxxxx",
                                labelText: "Father/Guardian's phone number",
                                isValid: controller.fatherPhoneNoValid.value,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: controller.fatherCNICController,
                                hintText: "35202xxxxxxxx",
                                labelText: "Father/Guardian's CNIC",
                                isValid: controller.fatherCNICValid.value,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: controller.studentRollNoController,
                                hintText: 'Student Roll No.',
                                labelText: 'Student Roll No.',
                                isValid: controller.studentRollNoValid.value,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: FutureBuilder<List<String>>(
                                future: controller.fetchClasses(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text('Error fetching classes'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Center(
                                        child: Text('No classes available'));
                                  } else {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white,
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          hintText: "Select class",
                                          labelText: "Class",
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: AppColors.appLightBlue,
                                                width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0),
                                          ),
                                        ),
                                        value: controller
                                                .selectedClass.value.isEmpty
                                            ? null
                                            : controller.selectedClass.value,
                                        onChanged: (newValue) {
                                          controller.selectedClass.value =
                                              newValue!;
                                        },
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: CustomBlueButton(
                                onPressed: controller.addStudent,
                                text: 'Add Student',
                                buttonText: 'Add',
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
        );
      }),
    );
  }
}
