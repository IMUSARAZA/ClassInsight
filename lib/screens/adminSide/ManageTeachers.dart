// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:classinsight/Services/Database_Service.dart';
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


@override
void initState() {
  super.initState();
  fetchTeachers();
}


  Future<void> fetchTeachers() async {

    String schoolID = 'buwF2J4lkLCdIVrHfgkP';

    setState(() {
      teachers = Database_Service.fetchTeachers(schoolID);
    });
  }

  void refreshTeachersList() {
        String schoolID = 'buwF2J4lkLCdIVrHfgkP';
 
      setState(() {
      teachers = Database_Service.fetchTeachers(schoolID);
    });
  }

  void searchTeacher(String value, BuildContext context) async {

    String schoolID = 'buwF2J4lkLCdIVrHfgkP';

    try{

    // showDialog(
    //       context: context,
    //       barrierDismissible: false, 
    //       builder: (BuildContext context) {
    //         return Center(
    //           child: CircularProgressIndicator(
    //             valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    //           ),
    //         );
    //       },
    //     );

        // Perform deletion
        await Database_Service.searchTeachers(schoolID, value);

        // Close loading indicator dialog
        // Navigator.of(context).pop();

        refreshTeachersList();

      }
      catch (e) {
        
        print('Error deleting teacher: $e');
        Navigator.of(context).pop(); 
        Get.snackbar('Error', 'Failed to delete teacher');
      
      }

  }
  


   void deleteTeacher(BuildContext context,String empID) async {
    String schoolID = 'buwF2J4lkLCdIVrHfgkP';

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


        await Database_Service.deleteTeacher(schoolID, empID);


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
      headingFontSize = 27;
    }
    if (screenWidth < 300) {
      addStdFontSize = 14;
      headingFontSize = 24;
    }
    if (screenWidth < 250) {
      addStdFontSize = 11;
      headingFontSize = 20;
    }
    if (screenWidth < 230) {
      addStdFontSize = 11;
      headingFontSize = 18;
    }

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
                      'Teachers',
                      style: Font_Styles.labelHeadingLight(context),
                    ),
                    centerTitle: true,
                    actions: <Widget>[
                      Container(
                        width: 48.0,
                      ),
                      TextButton(
                        onPressed: () {
                            Get.toNamed("/AddTeacher");
                          },
                        
                        child: Text(
                          "Add",
                          style: Font_Styles.labelHeadingLight(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Text(
                'Teachers',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25, 
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),     
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
              child: CustomTextField(
                controller: searchTeacherController,
                hintText: 'Search by name or employee ID.',
                labelText: 'Search Teacher',
                isValid: teachersValid,
                onChanged: (value) {
                print('Search teacher value: $value');
                searchTeacher(value,context);         
            },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            FutureBuilder<List<Teacher>>(
                  future: teachers,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Teacher>> snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
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
                          style: TextStyle(
                            color: Colors.red,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      print('No teachers found in the snapshot');
                      return Center(
                        child: Text(
                          'No Teachers found',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.04,
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
                                'Employee ID',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.03,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.03,
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
                                      MediaQuery.of(context).size.width *
                                          0.03,
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
                                      MediaQuery.of(context).size.width *
                                          0.03,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Classes',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.03,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Subjects',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.03,
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
                                      MediaQuery.of(context).size.width *
                                          0.03,
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
                                      MediaQuery.of(context).size.width *
                                          0.03,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        teacher.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        teacher.gender,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        teacher.fatherName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        teacher.classes.join(', '),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        teacher.subjects.entries
                                            .map((entry) =>
                                                '${entry.key}: ${entry.value.join(', ')}')
                                            .join('\n'),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      GestureDetector(
                                        onTap: () {
                                          print(
                                              "Edit button pressed for teacher: ${teacher.name}");

                                          // Navigate to edit screen
                                          // Example:
                                          // Navigator.pushNamed(
                                          //   context,
                                          //   '/EditTeacher',
                                          //   arguments: teacher,
                                          // ).then((_) => controller.fetchTeachers('your_school_id_here'));
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
                                             print( "Delete button pressed for teacher: ${teacher.name}");
                                             deleteTeacher(context, teacher.empID);
                                           },
                                           child: const Icon(
                                             FontAwesomeIcons.trashAlt,
                                             color: Colors.black,
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
         ),
       );
     }
   }





