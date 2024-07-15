// ignore_for_file: prefer_const_constructors

import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/screens/adminSide/AddStudent.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/screens/adminSide/EditStudent.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MaterialApp(
      routes: {
        '/AddStudent': (context) => AddStudent(),
        '/EditStudent': (context) => EditStudent(),
      },
      home: ManageStudents(),
      debugShowCheckedModeBanner: false,
    ));
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class ManageStudents extends StatefulWidget {
  const ManageStudents({Key? key}) : super(key: key);

  @override
  _ManageStudentsState createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  Future<List<Student>>? studentsList;
  String selectedClass = '2A';
  TextEditingController searchController = TextEditingController();
  bool searchValid = true;

  @override
  void initState() {
    super.initState();
    // Load initial student list
    studentsList =
        Database_Service.getStudentsOfASpecificClass('School1', selectedClass);
  }

  void refreshStudentList() {
    setState(() {
      studentsList =
          Database_Service.getStudentsOfASpecificClass('School1', selectedClass);
    });
  }

  void deleteStudent(BuildContext context, String schoolID, String studentID) async {
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

    // Delete student if confirmed
    if (confirmDelete) {
      try {
        // Show loading indicator while deleting
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismiss on tap outside
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          },
        );

        // Perform deletion
        await Database_Service.deleteStudent(schoolID, studentID);

        // Close loading indicator dialog
        Navigator.of(context).pop();

        // Refresh student list after deletion
        refreshStudentList();

      } catch (e) {
        // Handle errors
        print('Error deleting student: $e');
        Navigator.of(context).pop(); // Close the loading indicator dialog on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete student')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/AddStudent');
            },
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'Add Student',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16, // Adjust as needed
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Text(
                'Students',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25, // Adjust as needed
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
              child: DropdownButtonFormField<String>(
                value: selectedClass,
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
                items:
                    <String>['2A', '1C', '3B', '3D', '4A'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedClass = newValue!;
                    refreshStudentList();
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: CustomTextField(
                controller: searchController,
                hintText: 'Search by name or roll no.',
                labelText: 'Search Student',
                isValid: searchValid,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            FutureBuilder<List<Student>>(
              future: studentsList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Student>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appLightBlue,
                    ),
                  );
                } else if (snapshot.hasError) {
                  print('Snapshot error: ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print('No students found in the snapshot');
                  return Center(
                    child: Text(
                      'No Students found',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Student Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Gender',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Father Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Result',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      rows: snapshot.data!
                          .map((Student student) => DataRow(
                                color: MaterialStateColor.resolveWith(
                                    (states) => AppColors.appDarkBlue),
                                cells: [
                                  DataCell(
                                    Text(
                                      student.studentRollNo,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      student.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      student.gender,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      student.fatherName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                        onTap: () {
                                          print(
                                              "Result button pressed for student: ${student.name}");
                                        },
                                        child: Icon(
                                          Icons.text_snippet_outlined,
                                          color: Colors.white,
                                        )),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                        onTap: () {
                                          print(
                                              "Edit button pressed for student: ${student.name}");

                                          Navigator.pushNamed(
                                            context,
                                            '/EditStudent',
                                            arguments: Student(
                                              studentID: student.studentID,
                                              name: student.name,
                                              gender: student.gender,
                                              bForm_challanId:
                                                  student.bForm_challanId,
                                              fatherName: student.fatherName,
                                              fatherPhoneNo:
                                                  student.fatherPhoneNo,
                                              fatherCNIC: student.fatherCNIC,
                                              studentRollNo:
                                                  student.studentRollNo,
                                              classSection:
                                                  student.classSection,
                                            ),
                                          ).then((_) => refreshStudentList());
                                        },
                                        child: Icon(FontAwesomeIcons.edit)),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {
                                        print(
                                            "Delete button pressed for student: ${student.name}");
                                        deleteStudent(context, 'School1',
                                            student.studentID);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

void deleteStudent(
    BuildContext context, String schoolID, String studentID) async {
  try {
    // Show the progress indicator dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss on tap outside
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        );
      },
    );

    // Delete student
    await Database_Service.deleteStudent(schoolID, studentID);

    // Close the dialog once deletion is complete
    Navigator.of(context).pop();

  } catch (e) {
    // Handle errors
    print('Error deleting student: $e');
    Navigator.of(context).pop(); // Close the dialog on error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete student')),
    );
  }
}