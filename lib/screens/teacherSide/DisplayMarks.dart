import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await GetStorage.init();
  } catch (e) {
    print(e.toString());
  }
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: DisplayMarks()));
}

class DisplayMarksController extends GetxController {
  var subjectsList = <String>[].obs;
  var studentsList = <Student>[].obs;
  var examsList = <String>[].obs;

  var selectedSubject = ''.obs;
  final String className = "2-A"; // Initialize with "2-A"

  Database_Service databaseService = Database_Service();
  var schoolId = "buwF2J4lkLCdIVrHfgkP";

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
    ever(selectedSubject, (_) => updateStudentResults());
  }

  void fetchInitialData() async {
    schoolId = "buwF2J4lkLCdIVrHfgkP";

    subjectsList.value =
        await Database_Service.fetchSubjects(schoolId, className);
    studentsList.value =
        await Database_Service.getStudentsOfASpecificClass(schoolId, className);
    examsList.value =
        await databaseService.fetchExamStructure(schoolId, className);
  }

  Future<Map<String, String>> fetchStudentResults(String studentID) async {
    Map<String, Map<String, String>>? studentResult =
        await databaseService.fetchStudentResultMap(schoolId, studentID);
    return studentResult[selectedSubject.value] ?? {};
  }

  void updateData() async {
    schoolId = "buwF2J4lkLCdIVrHfgkP";

    subjectsList.value =
        await Database_Service.fetchSubjects(schoolId, className);
    studentsList.value =
        await Database_Service.getStudentsOfASpecificClass(schoolId, className);
    examsList.value =
        await databaseService.fetchExamStructure(schoolId, className);
  }

  void updateStudentResults() async {
    studentsList.refresh();
  }
}

class DisplayMarks extends StatelessWidget {
  final DisplayMarksController controller = Get.put(DisplayMarksController());

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                        // Implement navigation logic if needed
                      },
                    ),
                    title: Center(
                      child: Text(
                        'Marks',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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
                  height: 0.07 * screenHeight,
                  width: screenWidth,
                  margin: EdgeInsets.only(bottom: 10.0),
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    'Subject Result',
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  child: Obx(() {
                    var examsList = controller.examsList;
                    if (examsList.isEmpty) {
                      return Container(
                        width: screenWidth,
                        height: 20,
                        padding: EdgeInsets.only(left: 30),
                        child: Center(
                          child: Text(
                            'No exams found for this Class',
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Obx(() {
                          var students = controller.studentsList;
                          return DataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Roll No.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Student Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              for (var exam in examsList)
                                DataColumn(
                                  label: Text(
                                    exam,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                            rows: students.map((student) {
                              return DataRow(
                                color: MaterialStateProperty.resolveWith<
                                    Color?>(
                                  (Set<MaterialState> states) {
                                    return AppColors.appOrange;
                                  },
                                ),
                                cells: [
                                  DataCell(Text(student.studentRollNo)),
                                  DataCell(Text(student.name)),
                                  for (var exam in examsList)
                                    DataCell(FutureBuilder<String>(
                                      future: controller
                                          .fetchStudentResults(student.studentID)
                                          .then((resultMap) {
                                        return resultMap[exam] ?? '-';
                                      }),
                                      builder: (context, resultSnapshot) {
                                        if (resultSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 30),
                                            child: Text('Loading...'),
                                          );
                                        } else if (resultSnapshot.hasError) {
                                          return Text('Error');
                                        } else {
                                          return Text(
                                              resultSnapshot.data ?? '-');
                                        }
                                      },
                                    )),
                                ],
                              );
                            }).toList(),
                          );
                        }),
                      );
                    }
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
