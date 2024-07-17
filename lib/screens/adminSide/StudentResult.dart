// ignore_for_file: prefer_const_constructors

import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/screens/adminSide/ManageStudents.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(StudentResult());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class StudentResult extends StatefulWidget {
  const StudentResult({super.key});

  @override
  State<StudentResult> createState() => _StudentResultState();
}

class _StudentResultState extends State<StudentResult> {
  Database_Service databaseService = Database_Service();
  late Student args;
  String studentID = '';
  Future<List<String>>? examsList;
  Future<List<String>>? subjectsList;
  Future<Map<String, Map<String, String>>>? resultMap;

  double resultFontSize = 16;
  double headingFontSize = 33;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Student;
    studentID = args.studentID;
    examsList = databaseService.fetchExamStructure(
        'buwF2J4lkLCdIVrHfgkP', args.classSection);
    subjectsList = Database_Service.fetchSubjects(
        'buwF2J4lkLCdIVrHfgkP', args.classSection);
    resultMap = databaseService.fetchStudentResultMap(
        'buwF2J4lkLCdIVrHfgkP', studentID);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 350) {
      resultFontSize = 14;
      headingFontSize = 25;
    }
    if (screenWidth < 300) {
      resultFontSize = 14;
      headingFontSize = 23;
    }
    if (screenWidth < 250) {
      resultFontSize = 11;
      headingFontSize = 20;
    }
    if (screenWidth < 230) {
      resultFontSize = 8;
      headingFontSize = 17;
    }

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
                children: [
                  Container(
                    height: screenHeight * 0.10,
                    width: screenWidth,
                    child: AppBar(
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
                          'Result',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: resultFontSize,
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
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      args.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: headingFontSize,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder<List<dynamic>>(
                      future:
                          Future.wait([examsList!, subjectsList!, resultMap!]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.appOrange,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No data found');
                        } else {
                          List<String> exams =
                              snapshot.data![0] as List<String>;
                          List<String> subjects =
                              snapshot.data![1] as List<String>;
                          Map<String, Map<String, String>> resultMap = snapshot
                              .data![2] as Map<String, Map<String, String>>;

                          return DataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Subjects',
                                  style: TextStyle(
                                    fontSize: resultFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...exams.map((exam) => DataColumn(
                                    label: Text(
                                      exam,
                                      style: TextStyle(
                                        fontSize: resultFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                              DataColumn(
                                label: Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: resultFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Grade',
                                  style: TextStyle(
                                    fontSize: resultFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            rows: subjects
                                .map(
                                  (subject) => DataRow(
                                    color: MaterialStateColor.resolveWith(
                                        (states) => AppColors.appOrange),
                                    cells: [
                                      DataCell(Text(
                                        subject,
                                        style: TextStyle(
                                          fontSize: resultFontSize,
                                        ),
                                      )),
                                      ...exams.map((exam) => DataCell(Text(
                                            resultMap[subject]?[exam] ??
                                                '-', // Display marks or placeholder
                                            style: TextStyle(
                                              fontSize: resultFontSize,
                                            ),
                                          ))),
                                      DataCell(Text(
                                        '-', // Placeholder for Total
                                        style: TextStyle(
                                          fontSize: resultFontSize,
                                        ),
                                      )),
                                      DataCell(Text(
                                        '-', // Placeholder for Grade
                                        style: TextStyle(
                                          fontSize: resultFontSize,
                                        ),
                                      )),
                                    ],
                                  ),
                                )
                                .toList(),
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
      ),
    );
  }
}
