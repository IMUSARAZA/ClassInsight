import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/utils/fontStyles.dart';
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
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MarksScreen()));
}
class MarksScreenController extends GetxController {
  var subjectsList = <String>[].obs;
  var marksTypeList = <String>[].obs;
  var studentsList = <Student>[].obs;
  final AdminHomeController school = Get.put(AdminHomeController());
  final totalMarksController = TextEditingController();

  var selectedSubject = ''.obs;
  var selectedMarksType = ''.obs;
  final RxString className = ''.obs; // Use RxString for reactive updates

  var totalMarksValid = true.obs;

  Database_Service databaseService = Database_Service();
  var schoolId = "buwF2J4lkLCdIVrHfgkP";

  @override
  void onInit() {
    super.onInit();
    className.value = Get.arguments['className'] ?? '1-A'; // Initialize with passed value or default
    fetchInitialData();
    ever(selectedSubject, (_) => updateStudentResults());
  }

  void fetchInitialData() async {
    schoolId = school.schoolId.value;

    subjectsList.value =
        await Database_Service.fetchSubjects(schoolId, className.value);
    studentsList.value =
        await Database_Service.getStudentsOfASpecificClass(schoolId, className.value);
    marksTypeList.value =
        await databaseService.fetchExamStructure(schoolId, className.value);
  }

  Future<Map<String, String>> fetchStudentResults(String studentID) async {
    Map<String, Map<String, String>>? studentResult =
        await databaseService.fetchStudentResultMap(schoolId, studentID);
    return studentResult[selectedSubject.value] ?? {};
  }

  void updateData() async {
    schoolId = school.schoolId.value;

    subjectsList.value =
        await Database_Service.fetchSubjects(schoolId, className.value);
    studentsList.value =
        await Database_Service.getStudentsOfASpecificClass(schoolId, className.value);
    marksTypeList.value =
        await databaseService.fetchExamStructure(schoolId, className.value);
  }

  void updateStudentResults() async {
    studentsList.refresh();
  }

  String getTotalMarks() {
    return totalMarksController.text.isEmpty ? "-" : totalMarksController.text;
  }
}


class MarksScreen extends StatelessWidget {
  final MarksScreenController controller = Get.put(MarksScreenController());

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
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    title: Text(
                      'Marks',
                      style: Font_Styles.labelHeadingLight(context),
                    ),
                    centerTitle: true,
                    actions: <Widget>[
                      Container(
                        width: 48.0,
                      ),
                      TextButton(
                        onPressed: () {
                          // Save action here
                        },
                        child: Text(
                          "Save",
                          style: Font_Styles.labelHeadingLight(context),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
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
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 15),
                  child: Obx(() {
                    var marksTypeList = controller.marksTypeList;
                    if (marksTypeList.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (!marksTypeList
                          .contains(controller.selectedMarksType.value)) {
                        controller.selectedMarksType.value =
                            marksTypeList.isNotEmpty ? marksTypeList[0] : '';
                      }

                      return DropdownButtonFormField<String>(
                        value: controller.selectedMarksType.value.isEmpty
                            ? null
                            : controller.selectedMarksType.value,
                        decoration: InputDecoration(
                          labelText: "Marks Type",
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
                        items: marksTypeList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.selectedMarksType.value = newValue;
                          }
                        },
                      );
                    }
                  }),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 15),
                  child: TextFormField(
                    controller: controller.totalMarksController,
                    autofocus: false,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Enter total marks',
                      labelText: 'Total Marks',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle: TextStyle(color: Colors.black),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10), // Adjust vertical padding as needed
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: controller.totalMarksValid.value
                              ? Colors.black
                              : Colors.red,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: AppColors.appOrange,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    var marksTypeList = controller.marksTypeList;
                    if (marksTypeList.isEmpty) {
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
                          var totalMarks = controller.getTotalMarks();
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
                              DataColumn(
                                label: Text(
                                  'Obtained Marks',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Marks',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            rows: students.map((student) {
                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    return AppColors.appOrange;
                                  },
                                ),
                                cells: [
                                  DataCell(Text(student.studentRollNo)),
                                  DataCell(Text(student.name)),
                                  DataCell(
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Enter',
                                        hintStyle: TextStyle(
                                          color: const Color.fromARGB(255, 162,
                                              159, 159), // Light gray hint text
                                          fontWeight: FontWeight
                                              .normal, // Ensure hint text is not bold
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical:
                                              4, // Adjust padding if needed
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide
                                              .none, // Remove the bottom border
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide
                                              .none, // Remove the bottom border when focused
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide
                                              .none, // Remove the bottom border on error
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide
                                              .none, // Remove the bottom border on error focus
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black, // Style input text
                                        fontWeight: FontWeight
                                            .normal, // Ensure input text is not bold
                                      ),
                                      onChanged: (value) {
                                        // Handle obtained marks input if needed
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    Text(totalMarks),
                                  ),
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
