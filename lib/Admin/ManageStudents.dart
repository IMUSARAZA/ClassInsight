// ignore_for_file: prefer_const_constructors

import 'package:classinsight/Const/Appcolors.dart';
import 'package:classinsight/Model/StudentModel.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/Admin/AddStudent.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MaterialApp(
      routes: {
        '/AddStudent': (context) => AddStudent(),
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
                        BorderSide(color: Appcolors.appLightBlue, width: 2.0),
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
                    studentsList = Database_Service.getStudentsOfASpecificClass(
                        'School1', selectedClass);
                    print(selectedClass);
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
                      color: Appcolors.appLightBlue,
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
                                color: WidgetStateColor.resolveWith(
                                    (states) => Appcolors.appDarkBlue),
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
                                        // Replace with your logic to handle edit action
                                      },
                                      child: Image.asset(
                                        "lib/Assets/result.png",
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {
                                        print(
                                            "Edit button pressed for student: ${student.name}");
                                        // Replace with your logic to handle edit action
                                      },
                                      child: Image.asset(
                                        "lib/Assets/edit.png",
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {
                                        print(
                                            "Delete button pressed for student: ${student.name}");
                                        // Replace with your logic to handle edit action
                                      },
                                      child: Image.asset(
                                        "lib/Assets/delete.png",
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.03,
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
