// ignore_for_file: prefer_const_constructors

import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/screens/adminSide/ManageStudents.dart';
import 'package:classinsight/utils/AppColors.dart';

class SubjectResult extends StatefulWidget {
  const SubjectResult({Key? key}) : super(key: key);

  @override
  State<SubjectResult> createState() => _SubjectResultState();
}

class _SubjectResultState extends State<SubjectResult> {
  Future<List<String>>? classesList;
  Future<List<String>>? subjectsList;
  Future<List<Student>>? studentsList;
  Future<List<String>>? examsList;
  Database_Service databaseService = Database_Service();

  double resultFontSize = 16;
  double headingFontSize = 31;
  String selectedClass = '2-A';
  String selectedSubject = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Function to fetch initial data
  void fetchData() {
    classesList = Database_Service.fetchAllClasses('buwF2J4lkLCdIVrHfgkP');
    subjectsList =
        Database_Service.fetchSubjects('buwF2J4lkLCdIVrHfgkP', selectedClass);
    studentsList = Database_Service.getStudentsOfASpecificClass(
        'buwF2J4lkLCdIVrHfgkP', selectedClass);
    examsList = databaseService.fetchExamStructure(
        'buwF2J4lkLCdIVrHfgkP', selectedClass);
  }

  void updateData() {
    subjectsList =
        Database_Service.fetchSubjects('buwF2J4lkLCdIVrHfgkP', selectedClass);
    studentsList = Database_Service.getStudentsOfASpecificClass(
        'buwF2J4lkLCdIVrHfgkP', selectedClass);
    examsList = databaseService.fetchExamStructure(
        'buwF2J4lkLCdIVrHfgkP', selectedClass);
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminHome()),
                          );
                        },
                      ),
                      title: Center(
                        child: Text(
                          'Marks',
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
                    height: 0.07 * screenHeight,
                    width: screenWidth,
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Subject wise Marks',
                      style: TextStyle(
                        fontSize: headingFontSize,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 10, 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Class',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15, // Adjust as needed
                        ),
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
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No classes found'));
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
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: AppColors.appOrange, width: 2.0),
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
                                updateData();
                              });
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 10, 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Subject',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15, // Adjust as needed
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 15),
                    child: FutureBuilder<List<String>>(
                      future: subjectsList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No subjects found'));
                        } else {
                          List<String> subjects = snapshot.data!;
                          if (!subjects.contains(selectedSubject)) {
                            selectedSubject = subjects[0];
                          }
                          return DropdownButtonFormField<String>(
                            value: selectedSubject,
                            decoration: InputDecoration(
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
                            items: subjects.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSubject = newValue!;
                              });
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder<List<String>>(
                        future: examsList,
                        builder: (context, examSnapshot) {
                          if (examSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              width: screenWidth,
                              height: 20,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text('Loading...')),
                            );
                          } else if (examSnapshot.hasError) {
                            return Text('Error: ${examSnapshot.error}');
                          } else if (!examSnapshot.hasData ||
                              examSnapshot.data!.isEmpty) {
                            return Text('No exams found');
                          } else {
                            List<String> exams = examSnapshot.data!;
                            return FutureBuilder<List<Student>>(
                              future: studentsList,
                              builder: (context, studentSnapshot) {
                                if (examSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox(
                                    width: screenWidth,
                                    height: 20,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 30),
                                        child: Text('Loading...')),
                                  );
                                } else if (studentSnapshot.hasError) {
                                  return Text(
                                      'Error: ${studentSnapshot.error}');
                                } else if (!studentSnapshot.hasData ||
                                    studentSnapshot.data!.isEmpty) {
                                  return Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Text('No students found'));
                                } else {
                                  List<Student> students =
                                      studentSnapshot.data!;
                                  return DataTable(
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'Roll No.',
                                          style: TextStyle(
                                            fontSize: resultFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Student Name',
                                          style: TextStyle(
                                            fontSize: resultFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      for (var exam in exams)
                                        DataColumn(
                                          label: Text(
                                            exam,
                                            style: TextStyle(
                                              fontSize: resultFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                    rows: students.map((student) {
                                      return DataRow(
                                        color: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            return AppColors
                                                .appOrange; // Set the desired color here
                                          },
                                        ),
                                        cells: [
                                          DataCell(Text(student.studentRollNo)),
                                          DataCell(Text(student.name)),
                                          for (var exam in exams)
                                            DataCell(FutureBuilder<
                                                Map<String, String>>(
                                              future: databaseService
                                                  .fetchStudentResultMap(
                                                      'buwF2J4lkLCdIVrHfgkP',
                                                      student.studentID)
                                                  .then((result) {
                                                return result![
                                                        selectedSubject] ??
                                                    {};
                                              }),
                                              builder:
                                                  (context, resultSnapshot) {
                                                if (resultSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 30),
                                                      child:
                                                          Text('Loading...'));
                                                } else if (resultSnapshot
                                                    .hasError) {
                                                  return Text('Error');
                                                } else {
                                                  String result = resultSnapshot
                                                          .data![exam] ??
                                                      '-';
                                                  return Text(result);
                                                }
                                              },
                                            )),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            );
                          }
                        },
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

Future<Map<String, String>> fetchStudentResults(
    Database_Service databaseService, String studentID, String subject) async {
  Map<String, Map<String, String>>? studentResult = await databaseService
      .fetchStudentResultMap('buwF2J4lkLCdIVrHfgkP', studentID);
  return studentResult?[subject] ?? {};
}
