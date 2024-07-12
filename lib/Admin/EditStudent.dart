// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:classinsight/Const/AppColors.dart';
import 'package:classinsight/Model/StudentModel.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({Key? key}) : super(key: key);

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  late Student args;
  String? selectedGender;
  String? selectedClass;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Student;
    selectedGender = args.gender;
    selectedClass = args.classSection;
    bForm_challanIdController.text = args.bForm_challanId;
    fatherNameController.text = args.fatherName;
    fatherPhoneNoController.text = args.fatherPhoneNo;
    fatherCNICController.text = args.fatherCNIC;
  }

  TextEditingController bForm_challanIdController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherPhoneNoController = TextEditingController();
  TextEditingController fatherCNICController = TextEditingController();

  bool bForm_challanIdValid = true;
  bool fatherNameValid = true;
  bool fatherPhoneNoValid = true;
  bool fatherCNICValid = true;

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Appcolors.appLightBlue,
        body: Container(
            height: screenHeight,
            width: screenWidth,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: screenHeight * 0.05,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Appcolors.appLightBlue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          'Edit Student',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: editStdFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.pushNamed(context, '/AddStudent');
                            print(selectedGender);
                            print(selectedClass);
                            print(bForm_challanIdController.text);
                            print(fatherNameController.text);
                            print(fatherPhoneNoController.text);
                            print(fatherCNICController.text);
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
                      ],
                    ),
                  ),
                  Container(
                    height: 0.10 * screenHeight,
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
                    child: Container(
                      width: screenWidth,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  args.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: nameFontSize,
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
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Appcolors.appLightBlue,
                                                width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1.0),
                                          ),
                                        ),
                                        value: selectedGender,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedGender = newValue!;
                                          });
                                        },
                                        items: <String>['Male', 'Female', 'Other']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 13, 0),
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          hintText: "Select your class",
                                          labelText: "Class",
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Appcolors.appLightBlue,
                                                width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1.0),
                                          ),
                                        ),
                                        value: selectedClass,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedClass = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          '2A',
                                          '1C',
                                          '3B',
                                          '3D',
                                          '4A'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
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
                                hintText: args.bForm_challanId,
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
                ],
              ),
            ),
          ),
        
      ),
    );
  }
}

