// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:async';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/models/SchoolModel.dart';
import 'package:classinsight/models/TeacherModel.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';

class ManageTeachers extends StatefulWidget {
  const ManageTeachers({super.key});

  @override
  State<ManageTeachers> createState() => _ManageTeachersState();
}

class _ManageTeachersState extends State<ManageTeachers> {
  Future<List<Teacher>> teachers = Future<List<Teacher>>.value([]);
  TextEditingController searchTeacherController = TextEditingController();
  bool teachersValid = true;
  late School school;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    school = Get.arguments as School;
    fetchTeachers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchTeacherController.dispose();
    super.dispose();
  }

  Future<void> fetchTeachers() async {
    setState(() {
      teachers = Database_Service.fetchTeachers(school.schoolId);
    });
  }

  void refreshTeachersList() {
    setState(() {
      teachers = Database_Service.fetchTeachers(school.schoolId);
    });
  }

  String capitalize(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }


 bool _containsDigits(String value) {
    return value.contains(RegExp(r'\d'));
  }


  void searchTeacher(String value, BuildContext context) {
    const duration = Duration(milliseconds: 700);



    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(duration, () async {

      if(_containsDigits(value))
      {
       try {
        setState(() {
          teachers = Database_Service.searchTeachersByEmployeeID(school.schoolId, value);
        });
      } catch (e) {
        print('Error searching for teacher: $e');
        Get.snackbar('Error', 'Failed to search for teacher');
      }     
      }
      else{
      String searchText = capitalize(value);

      print('Searching for teacher: $searchText');

      try {
        setState(() {
          teachers = Database_Service.searchTeachersByName(school.schoolId, searchText);
        });
      } catch (e) {
        print('Error searching for teacher: $e');
        Get.snackbar('Error', 'Failed to search for teacher');
      }
      }
    });
  }

  void deleteTeacher(BuildContext context, String empID) async {

    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This will delete this teacher permanently'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
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
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          },
        );

        await Database_Service.deleteTeacher(school.schoolId, empID);

        Navigator.of(context).pop();

        refreshTeachersList();
      } catch (e) {
        print('Error deleting teacher: $e');
        Navigator.of(context).pop();
        Get.snackbar('Error', 'Failed to delete teacher');
      }
    }
  }

  double addStdFontSize = 16;
  double headingFontSize = 33;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 350) {
      addStdFontSize = 14;
      headingFontSize = 25;
    }
    if (screenWidth < 300) {
      addStdFontSize = 14;
      headingFontSize = 23;
    }
    if (screenWidth < 250) {
      addStdFontSize = 11;
      headingFontSize = 20;
    }
    if (screenWidth < 230) {
      addStdFontSize = 8;
      headingFontSize = 17;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: screenHeight * 0.10,
                width: screenWidth,
                child: AppBar(
                  backgroundColor: Colors.white,
                  title: Text(
                    'Teachers',
                    style: Font_Styles.labelHeadingLight(context),
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    Container(
                      width: 48.0,
                    ),
                    TextButton(
                      onPressed: () async {
                        await Get.toNamed("/AddTeacher", arguments: school);
                        fetchTeachers();
                      },
                      child: Text(
                        "Add Teacher",
                        style: Font_Styles.labelHeadingLight(context,color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 10, 5),
                child: Text(
                  'Teachers',
                  style: Font_Styles.mediumHeadingBold(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                child: CustomTextField(
                  controller: searchTeacherController,
                  hintText: 'Search by name & Employee ID',
                  labelText: 'Search Teacher',
                  isValid: teachersValid,
                  onChanged: (value) {
                    searchTeacher(value, context);
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              FutureBuilder<List<Teacher>>(
                future: teachers,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Teacher>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.appLightBlue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print('Snapshot error: ${snapshot.error}');
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: Font_Styles.dataTableTitle(context, MediaQuery.of(context).size.width * 0.04),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print('No teachers found in the snapshot');
                    return Center(
                      child: Text(
                        'No Teachers found',
                        style: Font_Styles.dataTableTitle(context, MediaQuery.of(context).size.width * 0.03),
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
                              'Employee ID',
                              style: Font_Styles.dataTableTitle(context, MediaQuery.of(context).size.width * 0.035),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Name',
                              style: Font_Styles.dataTableTitle(context, MediaQuery.of(context).size.width * 0.035),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Gender',
                              style: Font_Styles.dataTableTitle(context, MediaQuery.of(context).size.width * 0.035),
                            ),
                          ),
                          DataColumn(
                                label: Text(
                                  'Email',
                                  style: Font_Styles.dataTableTitle(context, MediaQuery.of(context).size.width * 0.035),
                                ),
                              ),
                          DataColumn(
                            label: Text(
                              'Father Name',
                              style: Font_Styles.dataTableTitle(context, MediaQuery.of(context).size.width * 0.035),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Classes',
                              style: Font_Styles.dataTableTitle(context,MediaQuery.of(context).size.width * 0.035),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                'Subjects',
                                style: Font_Styles.dataTableTitle(context,MediaQuery.of(context).size.width * 0.035),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Edit',
                              style: Font_Styles.dataTableTitle(context, MediaQuery.of(context).size.width * 0.035),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Delete',
                              style: Font_Styles.dataTableTitle(context, MediaQuery.of(context).size.width * 0.035),
                            ),
                          ),
                        ],
                        rows: snapshot.data!
                            .map(
                              (Teacher teacher) => DataRow(
                                color: MaterialStateColor.resolveWith(
                                    (states) => AppColors.appDarkBlue),
                                cells: [
                                  DataCell(
                                    Text(
                                      teacher.empID,
                                      style: Font_Styles.dataTableRows(context, MediaQuery.of(context).size.width * 0.035),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      teacher.name,
                                      style: Font_Styles.dataTableRows(context, MediaQuery.of(context).size.width * 0.035),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      teacher.gender,
                                      style: Font_Styles.dataTableRows(context, MediaQuery.of(context).size.width * 0.035),
                                    ),
                                  ),
                                  DataCell(
                                        Text(
                                          teacher.email,
                                          style: Font_Styles.dataTableRows(context, MediaQuery.of(context).size.width * 0.035),
                                        ),
                                      ),
                                  DataCell(
                                    Text(
                                      teacher.fatherName,
                                      style: Font_Styles.dataTableRows(context, MediaQuery.of(context).size.width * 0.035),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      teacher.classes.join(', '),
                                      style: Font_Styles.dataTableRows(context, MediaQuery.of(context).size.width * 0.035),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: teacher.subjects.entries
                                                  .map((entry) {
                                                return Tooltip(
                                                  message: entry.value.join(', '),
                                                  child: Text(
                                                    '${entry.key}: ${entry.value.join(', ')}',
                                                    style: Font_Styles.dataTableRows(context, MediaQuery.of(context).size.width * 0.03),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () async {       
                                        await Get.toNamed("/EditTeacher",
                                            arguments: [teacher, school]);  
                                        fetchTeachers();
                                      },
                                      child: const Icon(
                                        FontAwesomeIcons.penToSquare,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {
                                        deleteTeacher(context, teacher.empID);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}