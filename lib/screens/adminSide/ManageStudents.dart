// ignore_for_file: prefer_const_constructors
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/utils/fontStyles.dart';
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
    fetchClasses();
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
                          'Fee Status',
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
                                TextButton(
                                    child: Text(student.feeStatus),
                                    onPressed: () {
                                      _showFeeStatusPopup(context, student);

                                      final studentController =
                                          Get.find<StudentController>();
                                      studentController.refreshStudentList();
                                    }),
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
                                          bFormChallanId:
                                              student.bFormChallanId,
                                          fatherName: student.fatherName,
                                          fatherPhoneNo: student.fatherPhoneNo,
                                          fatherCNIC: student.fatherCNIC,
                                          studentRollNo: student.studentRollNo,
                                          classSection: student.classSection,
                                          feeStatus: student.feeStatus,
                                          feeStartDate: student.feeStartDate,
                                          feeEndDate: student.feeEndDate),
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
                                          bFormChallanId:
                                              student.bFormChallanId,
                                          fatherName: student.fatherName,
                                          fatherPhoneNo: student.fatherPhoneNo,
                                          fatherCNIC: student.fatherCNIC,
                                          studentRollNo: student.studentRollNo,
                                          classSection: student.classSection,
                                          feeStatus: student.feeStatus,
                                          feeStartDate: student.feeStartDate,
                                          feeEndDate: student.feeEndDate),
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
void _showFeeStatusPopup(BuildContext context, Student student) {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final AdminHomeController school = Get.find();
  
  // Initialize with existing values
  String feeStatus = student.feeStatus;
  String originalStartDate = student.feeStartDate;
  String originalEndDate = student.feeEndDate;

  // Set controllers with existing values
  startDateController.text = originalStartDate;
  endDateController.text = originalEndDate;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update Fee Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    startDateController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: TextField(
                controller: endDateController,
                decoration: InputDecoration(labelText: 'End Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    endDateController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: DropdownButtonFormField<String>(
                value: ['paid', 'unpaid'].contains(student.feeStatus)
                    ? student.feeStatus
                    : null,
                items: ['paid', 'unpaid'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  feeStatus = newValue!;
                },
                decoration: InputDecoration(
                  labelText: 'Fee Status',
                  border: OutlineInputBorder(),
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Update'),
            onPressed: () async {
              // Only update the start date and end date if they are not empty
              String updatedStartDate = startDateController.text.isNotEmpty
                  ? startDateController.text
                  : originalStartDate;
              String updatedEndDate = endDateController.text.isNotEmpty
                  ? endDateController.text
                  : originalEndDate;

              student.feeStatus = feeStatus;
              student.feeStartDate = updatedStartDate;
              student.feeEndDate = updatedEndDate;

              try {
                await Database_Service.updateFeeStatus(
                    school.schoolId.value,
                    student.studentID,
                    feeStatus,
                    updatedStartDate,
                    updatedEndDate);

                Navigator.of(context).pop();
              } catch (e) {
                print('Error updating fee status: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update fee status')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
