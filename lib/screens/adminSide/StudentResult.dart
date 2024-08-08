import 'package:classinsight/firebase_options.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:get/get.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Controller for managing student results
class StudentResultController extends GetxController {
  var student = Student(
    name: '',
    gender: '',
    bFormChallanId: '',
    fatherName: '',
    fatherPhoneNo: '',
    fatherCNIC: '',
    studentID: '',
    classSection: '',
    feeStatus: '',
    feeStartDate: '',
    feeEndDate: '',
    studentRollNo: '',
  ).obs;
  var examsList = <String>[].obs;
  var subjectsList = <String>[].obs;
  var resultMap = <String, Map<String, String>>{}.obs;
  var isLoading = true.obs;
  final String schoolId;

  StudentResultController(this.schoolId);

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void setStudent(Student newStudent) {
    student.value = newStudent;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      examsList.value = await Database_Service()
          .fetchExamStructure(schoolId, student.value.classSection);
      subjectsList.value = await Database_Service.fetchSubjects(
          schoolId, student.value.classSection);
      resultMap.value = await Database_Service()
          .fetchStudentResultMap(schoolId, student.value.studentID);
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<String> fetchTotalObtainedMarks(String studentID, String subject) async {
  //   try {
  //     DocumentSnapshot studentDoc = await FirebaseFirestore.instance
  //         .collection('Schools')
  //         .doc(schoolId)
  //         .collection('Students')
  //         .doc(studentID)
  //         .get();

  //     if (studentDoc.exists) {
  //       Map<String, dynamic> resultMap = studentDoc['resultMap'];
  //       int totalSum = 0;

  //       // Get the results for the selected subject
  //       var subjectResults = resultMap[subject] ?? {};

  //       for (var examType in examsList) {
  //         var marks = subjectResults[examType] ?? '-';
  //         if (marks is String) {
  //           RegExp regex = RegExp(r'(\d+)/(\d+)');
  //           Match? match = regex.firstMatch(marks);
  //           if (match != null) {
  //             int obtainedMarks = int.tryParse(match.group(1) ?? '0') ?? 0;
  //             totalSum += obtainedMarks;
  //           }
  //         }
  //       }

  //       return totalSum.toString();
  //     } else {
  //       return '0';
  //     }
  //   } catch (e) {
  //     print('Error fetching resultMap: $e');
  //     return '0';
  //   }
  // }

  // Future<String> fetchStudentTotalMarksSum(String studentID, String subject) async {
  //   try {
  //     DocumentSnapshot studentDoc = await FirebaseFirestore.instance
  //         .collection('Schools')
  //         .doc(schoolId)
  //         .collection('Students')
  //         .doc(studentID)
  //         .get();

  //     if (studentDoc.exists) {
  //       Map<String, dynamic> resultMap = studentDoc['resultMap'];
  //       int totalSum = 0;

  //       var subjectResults = resultMap[subject] ?? {};

  //       for (var examType in examsList) {
  //         var marks = subjectResults[examType] ?? '-';
  //         if (marks is String) {
  //           RegExp regex = RegExp(r'\d+/(\d+)');
  //           Match? match = regex.firstMatch(marks);
  //           if (match != null) {
  //             int totalMarks = int.tryParse(match.group(1) ?? '0') ?? 0;
  //             totalSum += totalMarks;
  //           }
  //         }
  //       }

  //       return totalSum.toString();
  //     } else {
  //       return '0';
  //     }
  //   } catch (e) {
  //     print('Error fetching resultMap: $e');
  //     return '0';
  //   }
  // }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentResult(),
    );
  }
}

class StudentResult extends StatelessWidget {
  final AdminHomeController school = Get.find();
  @override
  Widget build(BuildContext context) {
    final Student student =
        ModalRoute.of(context)!.settings.arguments as Student;
    final String schoolId = school.schoolId.value;

    // Initialize the controller with the school ID
    final StudentResultController controller =
        Get.put(StudentResultController(schoolId));
    controller.setStudent(student);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => ManageStudents()),
            // );
          },
        ),
        title: Center(
          child: Text(
            'Result',
            style: Font_Styles.labelHeadingLight(context),
          ),
        ),
        actions: <Widget>[
          Container(
            width: 48.0, // Adjust as needed
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;

        double resultFontSize = screenWidth < 350
            ? (screenWidth < 300 ? (screenWidth < 250 ? 11 : 14) : 14)
            : 16;
        double headingFontSize = screenWidth < 350
            ? (screenWidth < 300 ? (screenWidth < 250 ? 20 : 23) : 25)
            : 33;

        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.appOrange),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 0.05 * screenHeight,
                      width: screenWidth,
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        controller.student.value.name,
                        textAlign: TextAlign.start,
                        style: Font_Styles.dataTableTitle(
                            context, headingFontSize),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(() {
                        List<String> exams = controller.examsList;
                        List<String> subjects = controller.subjectsList;
                        Map<String, Map<String, String>> resultMap =
                            controller.resultMap;

                        return DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                'Subjects',
                                style: Font_Styles.dataTableTitle(
                                    context, screenWidth * 0.04),
                              ),
                            ),
                            ...exams.map((exam) => DataColumn(
                                  label: Text(
                                    exam,
                                    style: Font_Styles.dataTableTitle(
                                        context, screenWidth * 0.04),
                                  ),
                                )),
                            // DataColumn(
                            //   label: Text(
                            //     'Obtained marks',
                            //     style: Font_Styles.dataTableTitle(
                            //         context, screenWidth * 0.04),
                            //   ),
                            // ),
                            // DataColumn(
                            //   label: Text(
                            //     'Total marks',
                            //     style: Font_Styles.dataTableTitle(
                            //         context, screenWidth * 0.04),
                            //   ),
                            // ),
                            // DataColumn(
                            //   label: Text(
                            //     'Grade',
                            //     style: Font_Styles.dataTableTitle(
                            //         context, screenWidth * 0.04),
                            //   ),
                            // ),
                          ],
                          rows: subjects
                              .map(
                                (subject) => DataRow(
                                  color: MaterialStateColor.resolveWith(
                                      (states) => AppColors.appOrange),
                                  cells: [
                                    DataCell(Text(
                                      subject,
                                      style: Font_Styles.dataTableRows(
                                          context, resultFontSize),
                                    )),
                                    ...exams.map((exam) => DataCell(Text(
                                          resultMap[subject]?[exam] ?? '-',
                                          style: Font_Styles.dataTableRows(
                                              context, resultFontSize),
                                        ))),
                                    // DataCell(FutureBuilder<String>(
                                    //   future: controller.fetchTotalObtainedMarks(
                                    //       controller.student.value.studentID,
                                    //       subject),
                                    //   builder: (context, snapshot) {
                                    //     if (snapshot.connectionState ==
                                    //         ConnectionState.waiting) {
                                    //       return Text(
                                    //         '-',
                                    //         style: Font_Styles.dataTableRows(
                                    //             context, resultFontSize),
                                    //       );
                                    //     } else if (snapshot.hasError) {
                                    //       return Text(
                                    //         'Error',
                                    //         style: Font_Styles.dataTableRows(
                                    //             context, resultFontSize),
                                    //       );
                                    //     } else {
                                    //       return Text(
                                    //         snapshot.data ?? '0',
                                    //         style: Font_Styles.dataTableRows(
                                    //             context, resultFontSize),
                                    //       );
                                    //     }
                                    //   },
                                    // )),
                                    // DataCell(FutureBuilder<String>(
                                    //   future:
                                    //       controller.fetchStudentTotalMarksSum(
                                    //           controller
                                    //               .student.value.studentID,
                                    //           subject),
                                    //   builder: (context, snapshot) {
                                    //     if (snapshot.connectionState ==
                                    //         ConnectionState.waiting) {
                                    //       return Text(
                                    //         '-',
                                    //         style: Font_Styles.dataTableRows(
                                    //             context, resultFontSize),
                                    //       );
                                    //     } else if (snapshot.hasError) {
                                    //       return Text(
                                    //         'Error',
                                    //         style: Font_Styles.dataTableRows(
                                    //             context, resultFontSize),
                                    //       );
                                    //     } else {
                                    //       return Text(
                                    //         snapshot.data ?? '0',
                                    //         style: Font_Styles.dataTableRows(
                                    //             context, resultFontSize),
                                    //       );
                                    //     }
                                    //   },
                                    // )),
                                    // DataCell(Text(
                                    //   calculateGrade(resultMap[subject] ?? {}),
                                    //   style: Font_Styles.dataTableRows(
                                    //       context, resultFontSize),
                                    // )),
                                  ],
                                ),
                              )
                              .toList(),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  // String calculateGrade(Map<String, String> subjectResults) {
  //   int totalMarks = 0;
  //   int obtainedMarks = 0;

  //   subjectResults.forEach((exam, marks) {
  //     if (marks.contains('/')) {
  //       var parts = marks.split('/');
  //       if (parts.length == 2) {
  //         obtainedMarks += int.tryParse(parts[0]) ?? 0;
  //         totalMarks += int.tryParse(parts[1]) ?? 0;
  //       }
  //     }
  //   });

  //   if (totalMarks == 0) {
  //     return '-';
  //   }

  //   double percentage = (obtainedMarks / totalMarks) * 100;
  //   if (percentage >= 90) {
  //     return 'A+';
  //   } else if (percentage >= 80) {
  //     return 'A';
  //   } else if (percentage >= 70) {
  //     return 'B';
  //   } else if (percentage >= 60) {
  //     return 'C';
  //   } else if (percentage >= 50) {
  //     return 'D';
  //   } else {
  //     return 'F';
  //   }
  // }
}
