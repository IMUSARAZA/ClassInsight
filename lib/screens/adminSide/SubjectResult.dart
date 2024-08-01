// ignore_for_file: prefer_const_constructors

import 'package:classinsight/utils/fontStyles.dart';
import 'package:get/get.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:classinsight/utils/AppColors.dart';

class SubjectResultController extends GetxController {
  var classesList = <String>[].obs;
  var subjectsList = <String>[].obs;
  var studentsList = <Student>[].obs;
  var examsList = <String>[].obs;

  var selectedClass = ''.obs;
  var selectedSubject = ''.obs;

  Database_Service databaseService = Database_Service();

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
    ever(selectedSubject, (_) => updateStudentResults());
  }

  void fetchInitialData() async {
    var schoolId = Get.find<AdminHomeController>().schoolId.value;

    classesList.value = await Database_Service.fetchAllClasses(schoolId);
    subjectsList.value =
        await Database_Service.fetchSubjects(schoolId, selectedClass.value);
    studentsList.value = await Database_Service.getStudentsOfASpecificClass(
        schoolId, selectedClass.value);
    examsList.value =
        await databaseService.fetchExamStructure(schoolId, selectedClass.value);
  }

  Future<Map<String, String>> fetchStudentResults(String studentID) async {
    Map<String, Map<String, String>>? studentResult =
        await databaseService.fetchStudentResultMap(
            Get.find<AdminHomeController>().schoolId.value, studentID);
    return studentResult[selectedSubject.value] ?? {};
  }

  void updateData() async {
    var schoolId = Get.find<AdminHomeController>().schoolId.value;

    subjectsList.value =
        await Database_Service.fetchSubjects(schoolId, selectedClass.value);
    studentsList.value = await Database_Service.getStudentsOfASpecificClass(
        schoolId, selectedClass.value);
    examsList.value =
        await databaseService.fetchExamStructure(schoolId, selectedClass.value);
  }

  void updateStudentResults() async {
    // Trigger UI update for students results
    studentsList.refresh();
  }
}

class SubjectResult extends StatelessWidget {
  final SubjectResultController controller = Get.put(SubjectResultController());

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
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
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Get.back();
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => AdminHome()),
                          // );
                        },
                      ),
                      title: Center(
                        child: Text(
                          'Marks',
                          style: Font_Styles.labelHeadingLight(context),
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
                    height: 0.07 * screenHeight,
                    width: screenWidth,
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Subject Result',
                      style: Font_Styles.largeHeadingBold(context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 15),
                    child: Obx(() {
                      var classesList = controller.classesList;
                      if (classesList.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (!classesList
                            .contains(controller.selectedClass.value)) {
                          controller.selectedClass.value =
                              classesList.isNotEmpty ? classesList[0] : '';
                        }

                        return DropdownButtonFormField<String>(
                          value: controller.selectedClass.value.isEmpty
                              ? null
                              : controller.selectedClass.value,
                          decoration: InputDecoration(
                            labelText: "Class",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppColors.appOrange, width: 2.0),
                            ),
                          ),
                          items: classesList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.selectedClass.value = newValue;
                              controller.updateData();
                            }
                          },
                        );
                      }
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 15),
                    child: Obx(() {
                      var subjectsList = controller.subjectsList;
                      if (subjectsList.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (!subjectsList
                            .contains(controller.selectedSubject.value)) {
                          controller.selectedSubject.value =
                              subjectsList.isNotEmpty ? subjectsList[0] : '';
                        }

                        return DropdownButtonFormField<String>(
                          value: controller.selectedSubject.value.isEmpty
                              ? null
                              : controller.selectedSubject.value,
                          decoration: InputDecoration(
                            labelText: "Subject",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppColors.appOrange, width: 2.0),
                            ),
                          ),
                          items: subjectsList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.selectedSubject.value = newValue;
                            }
                          },
                        );
                      }
                    }),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Obx(() {
                            var subjectsList = controller.subjectsList;
                            if (subjectsList.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                                child: Text(
                                  'No subjects found...',
                                  style: Font_Styles.labelHeadingLight(context),
                                ),
                              );
                            } else {
                              return Container(); // Placeholder to maintain layout structure
                            }
                          }),
                          Obx(() {
                            var examsList = controller.examsList;
                            if (examsList.isEmpty) {
                              return Container(
                                width: screenWidth,
                                height: 20,
                                padding: EdgeInsets.only(left: 30),
                                child: Center(
                                  child: Text(
                                    'No exams found for this Class',
                                    style: Font_Styles.labelHeadingLight(context),
                                  ),
                                ),
                              );
                            } else {
                              return Obx(() {
                                var students = controller.studentsList;
                                return DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'Roll No.',
                                        style: Font_Styles.dataTableTitle(context, screenWidth * 0.04),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Student Name',
                                        style: Font_Styles.dataTableTitle(context, screenWidth * 0.04),
                                      ),
                                    ),
                                    for (var exam in examsList)
                                      DataColumn(
                                        label: Text(
                                          exam,
                                          style: Font_Styles.dataTableTitle(context, screenWidth * 0.04),
                                        ),
                                      ),
                                  ],
                                  rows: students.map((student) {
                                    return DataRow(
                                      color: MaterialStateProperty.resolveWith<
                                          Color?>(
                                        (Set<MaterialState> states) {
                                          return AppColors
                                              .appOrange; // Set the desired color here
                                        },
                                      ),
                                      cells: [
                                        DataCell(Text(student.studentRollNo)),
                                        DataCell(Text(student.name)),
                                        for (var exam in examsList)
                                          DataCell(Obx(() {
                                            return FutureBuilder<String>(
                                              future: controller
                                                  .fetchStudentResults(
                                                      student.studentID)
                                                  .then((resultMap) {
                                                return resultMap[exam] ?? '-';
                                              }),
                                              builder:
                                                  (context, resultSnapshot) {
                                                if (resultSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30),
                                                    child: Text('Loading...'),
                                                  );
                                                } else if (resultSnapshot
                                                    .hasError) {
                                                  return Text('Error');
                                                } else {
                                                  return Text(
                                                      resultSnapshot.data ??
                                                          '-');
                                                }
                                              },
                                            );
                                          })),
                                      ],
                                    );
                                  }).toList(),
                                );
                              });
                            }
                          }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
