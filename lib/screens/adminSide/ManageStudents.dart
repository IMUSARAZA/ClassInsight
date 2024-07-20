import 'dart:async';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/screens/adminSide/AddStudent.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:classinsight/screens/adminSide/EditStudent.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class StudentController extends GetxController {
  var studentsList = <Student>[].obs;
  var classesList = <String>[].obs;
  var selectedClass = ''.obs; // Initialize as an empty string
  var searchValid = true.obs;

  final AdminHomeController school = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchClasses(); // Fetch classes first
  }

  void fetchStudents() async {
    if (selectedClass.isNotEmpty) {
      var students = await Database_Service.getStudentsOfASpecificClass(
          school.schoolId.value, selectedClass.value);
      studentsList.value = students;
    }
  }

  void fetchClasses() async {
    var classes = await Database_Service.fetchAllClasses(school.schoolId.value);
    classesList.value = classes;

    // Initialize selectedClass if it's not set or not in the list
    if (classes.isNotEmpty && selectedClass.isEmpty) {
      selectedClass.value = classes.first;
    }

    // Fetch students after classes have been loaded
    fetchStudents();
  }

  void refreshStudentList() {
    fetchStudents();
  }

  void searchStudent(String value) async {
    if (_containsDigits(value)) {
      var students = await Database_Service.searchStudentsByRollNo(
          school.schoolId.value, selectedClass.value, value);
      studentsList.value = students;
    } else {
      var searchText = capitalize(value);
      var students = await Database_Service.searchStudentsByName(
          school.schoolId.value, selectedClass.value, searchText);
      studentsList.value = students;
    }
  }

  bool _containsDigits(String value) {
    return value.contains(RegExp(r'\d'));
  }

  String capitalize(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void deleteStudent(BuildContext context, String studentID) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This will delete this student permanently'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          },
        );

        await Database_Service.deleteStudent(school.schoolId.value, studentID);

        Navigator.of(context).pop();

        refreshStudentList();
      } catch (e) {
        print('Error deleting student: $e');
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete student')),
        );
      }
    }
  }
}

class ManageStudents extends StatelessWidget {
  final StudentController studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Manage Students",
          style: Font_Styles.labelHeadingRegular(context),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHome()),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/AddStudent');
            },
            child: Text('Add Student',
                style: Font_Styles.labelHeadingRegular(context)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 10, 5),
              child: Text(
                'Students',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30, // Adjust as needed
                  fontWeight: FontWeight.w900,
                ),
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
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  value: studentController.selectedClass.value,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: AppColors.appLightBlue, width: 2.0),
                    ),
                  ),
                  items: studentController.classesList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    studentController.selectedClass.value = newValue!;
                    studentController.refreshStudentList();
                  },
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: CustomTextField(
                controller: TextEditingController(),
                hintText: 'Search by name or roll no.',
                labelText: 'Search Student',
                isValid: studentController.searchValid.value,
                onChanged: (String value) {
                  studentController.searchStudent(value);
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Obx(() {
              if (studentController.studentsList.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.appLightBlue,
                  ),
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    showBottomBorder: true,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Roll No.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Student Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Gender',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Father Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Father Phone',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Father CNIC',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Result',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    rows: studentController.studentsList
                        .map(
                          (student) => DataRow(
                            color: MaterialStateColor.resolveWith(
                                (states) => AppColors.appDarkBlue),
                            cells: [
                              DataCell(
                                Text(
                                  student.studentRollNo,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  student.name,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  student.gender,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  student.fatherName,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  student.fatherPhoneNo,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  student.fatherCNIC,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(
                                    Icons.text_snippet_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    print(
                                        "Result button pressed for student: ${student.name}");
                                    Navigator.pushNamed(
                                      context,
                                      '/StudentResult',
                                      arguments: Student(
                                        studentID: student.studentID,
                                        name: student.name,
                                        gender: student.gender,
                                        bFormChallanId: student.bFormChallanId,
                                        fatherName: student.fatherName,
                                        fatherPhoneNo: student.fatherPhoneNo,
                                        fatherCNIC: student.fatherCNIC,
                                        studentRollNo: student.studentRollNo,
                                        classSection: student.classSection,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.edit),
                                  onPressed: () {
                                    print(student);
                                    Navigator.pushNamed(
                                      context,
                                      '/EditStudent',
                                      arguments: Student(
                                        studentID: student.studentID,
                                        name: student.name,
                                        gender: student.gender,
                                        bFormChallanId: student.bFormChallanId,
                                        fatherName: student.fatherName,
                                        fatherPhoneNo: student.fatherPhoneNo,
                                        fatherCNIC: student.fatherCNIC,
                                        studentRollNo: student.studentRollNo,
                                        classSection: student.classSection,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    studentController.deleteStudent(
                                        context, student.studentID);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
