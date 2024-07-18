// ignore_for_file: prefer_const_constructors

import 'package:classinsight/models/StudentModel.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:classinsight/screens/adminSide/ManageStudents.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:classinsight/widgets/CustomTextField.dart';
import 'package:classinsight/services/Database_Service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({Key? key}) : super(key: key);

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  AdminHomeController school = Get.put(AdminHomeController());
  late Student args;
  String selectedGender = 'Male';
  String selectedClass = '2-A';
  String studentID = '';
  String changedGender = '';
  String changedClass = '';
  bool? isEditingName;
  Future<List<String>>? classesList;

  TextEditingController nameController = TextEditingController();
  TextEditingController bForm_challanIdController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherPhoneNoController = TextEditingController();
  TextEditingController fatherCNICController = TextEditingController();

  bool bForm_challanIdValid = true;
  bool fatherNameValid = true;
  bool fatherPhoneNoValid = true;
  bool fatherCNICValid = true;

  @override
  void initState() {
    super.initState();
    // Initialize values when the widget is first created
    classesList = Database_Service.fetchAllClasses(school.schoolId.value);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Student;
    studentID = args.studentID;

    // Set initial values only if they are empty
    if (changedGender.isEmpty && changedClass.isEmpty) {
      selectedGender = args.gender;
      selectedClass = args.classSection;
      changedGender = args.gender;
      changedClass = args.classSection;
      nameController.text = args.name;
      bForm_challanIdController.text = args.bFormChallanId;
      fatherNameController.text = args.fatherName;
      fatherPhoneNoController.text = args.fatherPhoneNo;
      fatherCNICController.text = args.fatherCNIC;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double editStdFontSize = 16;
    double headingFontSize = 33;
    double nameFontSize = 25;
    double rollNoFontSize = 22;

    if (screenWidth < 350) {
      editStdFontSize = 14;
      headingFontSize = 27;
      nameFontSize = 22;
      rollNoFontSize = 19;
    }
    if (screenWidth < 300) {
      editStdFontSize = 14;
      headingFontSize = 24;
      nameFontSize = 19;
      rollNoFontSize = 16;
    }
    if (screenWidth < 250) {
      editStdFontSize = 11;
      headingFontSize = 20;
      nameFontSize = 16;
      rollNoFontSize = 13;
    }
    if (screenWidth < 230) {
      editStdFontSize = 8;
      headingFontSize = 15;
      nameFontSize = 13;
      rollNoFontSize = 11;
    }

    return Scaffold(
      backgroundColor: AppColors.appLightBlue,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: screenHeight * 0.10,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: AppColors.appLightBlue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        'Edit Student',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: editStdFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: TextButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.appLightBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                          Map<String, dynamic> updatedData = {
                            'Name': nameController.text,
                            'Gender': changedGender,
                            'BForm_challanId': bForm_challanIdController.text,
                            'FatherName': fatherNameController.text,
                            'FatherPhoneNo': fatherPhoneNoController.text,
                            'FatherCNIC': fatherCNICController.text,
                            'StudentRollNo': args.studentRollNo,
                            'ClassSection': changedClass,
                          };

                          print("updated data: $updatedData");

                          await Database_Service.updateStudent(
                            'buwF2J4lkLCdIVrHfgkP',
                            studentID,
                            updatedData,
                          );

                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageStudents(),
                            ),
                          );
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.08 * screenHeight,
                width: screenWidth,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  'Edit Student',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: screenWidth,
                    height: 0.82 * screenHeight - 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // Toggle editing state for name
                                      isEditingName = !(isEditingName ?? false);
                                      // Update text controller with current value when entering edit mode
                                      if (isEditingName!) {
                                        nameController.text = args.name;
                                      }
                                    });
                                  },
                                  child: isEditingName ==
                                          true // Check explicitly for true, not null or false
                                      ? SizedBox(
                                          // Wrap with SizedBox for constraints
                                          width:
                                              200, // Adjust width as per your layout needs
                                          child: TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              hintText: "Edit name",
                                              labelText: "Name",
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                borderSide: BorderSide(
                                                  color: AppColors.appLightBlue,
                                                  width: 2.0,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          args.name.split(' ')[
                                              0], // Get only the first name
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: nameFontSize,
                                          ),
                                        ),
                                ),
                                Text(
                                  args.studentRollNo,
                                  style: TextStyle(
                                    fontSize: rollNoFontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        hintText: "Select your gender",
                                        labelText: "Gender",
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors
                                                .appLightBlue, // Use your app's light blue color
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      value: selectedGender,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedGender = newValue!;
                                          changedGender = newValue;
                                        });
                                      },
                                      items: <String>['Male', 'Female', 'Other']
                                          .map<DropdownMenuItem<String>>(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: FutureBuilder<List<String>>(
                                      future: classesList,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppColors.appLightBlue,
                                            ),
                                          ));
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                              child: Text('No classes found'));
                                        } else {
                                          List<String> classes = snapshot.data!;
                                          if (!classes
                                              .contains(selectedClass)) {
                                            selectedClass = classes[0];
                                          }
                                          return DropdownButtonFormField<
                                              String>(
                                            value: selectedClass,
                                            decoration: InputDecoration(
                                              hintText: "Select your class",
                                              labelText: "Class",
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                borderSide: BorderSide(
                                                  color: AppColors
                                                      .appLightBlue, // Use your app's light blue color
                                                  width: 2.0,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
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
                                                changedClass = newValue;
                                              });
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: CustomTextField(
                              controller: bForm_challanIdController,
                              hintText: args.bFormChallanId,
                              labelText: 'B-Form/Challan ID',
                              isValid: bForm_challanIdValid,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: CustomTextField(
                              controller: fatherNameController,
                              hintText: args.fatherName,
                              labelText: "Father's name",
                              isValid: fatherNameValid,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: CustomTextField(
                              controller: fatherPhoneNoController,
                              hintText: args.fatherPhoneNo,
                              labelText: "Father's phone no.",
                              isValid: fatherPhoneNoValid,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: CustomTextField(
                              controller: fatherCNICController,
                              hintText: args.fatherCNIC,
                              labelText: "Father's CNIC",
                              isValid: fatherCNICValid,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
