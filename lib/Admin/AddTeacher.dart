import 'package:classinsight/Const/AppColors.dart';
import 'package:classinsight/Services/Database_Service.dart';

import 'package:classinsight/Widgets/CustomBlueButton.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const AddTeacher());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class AddTeacher extends StatefulWidget {
  const AddTeacher({super.key});

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}
    String schoolId = 'School1';

class ClassSubject {
  String className;
  List<String> subjects;

  ClassSubject({required this.className, required this.subjects});
}

class _AddTeacherState extends State<AddTeacher> {
  TextEditingController empIDController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  bool empIDValid = true;
  bool nameValid = true;
  bool genderValid = true;
  bool cnicValid = true;
  bool fatherNameValid = true;
  bool phoneNoValid = true;

  String selectedGender = '';
  String selectedClass = '';
  String selectedClassTeacher = '';
  double addStdFontSize = 16;
  double headingFontSize = 33;

  List<String> selectedClasses = [];
  List<ClassSubject> classesSubjects = [];
  Map<String, List<String>> selectedSubjects = {};

  @override
  void initState() {
    super.initState();
    fetchClassesAndSubjects();
  }

  void fetchClassesAndSubjects() async {

    List<String> classes = await Database_Service.fetchClasses(schoolId);
    List<ClassSubject> fetchedClassesSubjects = [];

    for (String className in classes) {
      print('Fetching subjects for class $className');
      List<String> subjects =
          await Database_Service.fetchSubjects(schoolId, className);
      fetchedClassesSubjects
          .add(ClassSubject(className: className, subjects: subjects));
    }

    setState(() {
      classesSubjects = fetchedClassesSubjects;
    });
  }

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
      addStdFontSize = 8;
      headingFontSize = 15;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Appcolors.appLightBlue,
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
                      backgroundColor: Appcolors.appLightBlue,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      title: Center(
                        child: Text(
                          'Add Teacher',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: addStdFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        Container(
                          width: 48.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.05 * screenHeight,
                    width: screenWidth,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Add New Teacher',
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                              child: CustomTextField(
                                controller: empIDController,
                                hintText: 'Employee ID',
                                labelText: 'Employee ID',
                                isValid: empIDValid,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 40, 30, 20),
                              child: CustomTextField(
                                controller: nameController,
                                hintText: 'Name',
                                labelText: 'Name',
                                isValid: nameValid,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.white,
                                ),
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    hintText: "Select your gender",
                                    labelText: "Gender",
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Appcolors.appLightBlue,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                  ),
                                  value: selectedGender.isEmpty
                                      ? null
                                      : selectedGender,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: cnicController,
                                hintText: '352020xxxxxxxx91',
                                labelText: 'CNIC No',
                                isValid: cnicValid,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: phoneNoController,
                                hintText: '0321xxxxxx12',
                                labelText: 'Phone Number',
                                isValid: phoneNoValid,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: fatherNameController,
                                hintText: "Father's name",
                                labelText: "Father's name",
                                isValid: fatherNameValid,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: MultiSelectDialogField(
                                backgroundColor: Appcolors.appLightBlue,
                                items: classesSubjects
                                    .map((classSubject) => MultiSelectItem(
                                        classSubject.className,
                                        classSubject.className))
                                    .toList(),
                                title: const Text("Avaialbale Classes"),
                                selectedColor: Colors.black,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                buttonIcon: const Icon(
                                  Icons.class_,
                                  color: Colors.black,
                                ),
                                buttonText: const Text(
                                  "Class to Assign",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                checkColor: Colors.white,
                                cancelText: const Text(
                                  "CANCEL",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                confirmText: const Text(
                                  "OK",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                onConfirm: (results) {
                                  setState(() {
                                    selectedClasses = results;
                                  });
                                },
                              ),
                            ),
                            for (var className in selectedClasses)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 20),
                                child: MultiSelectDialogField(
                                  backgroundColor: Appcolors.appLightBlue,
                                  items: classesSubjects
                                      .firstWhere((classSubject) =>
                                          classSubject.className == className)
                                      .subjects
                                      .map((subject) =>
                                          MultiSelectItem(subject, subject))
                                      .toList(),
                                  title: Text("Subjects for $className"),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  buttonIcon: const Icon(
                                    Icons.subject,
                                    color: Colors.black,
                                  ),
                                  buttonText: Text(
                                    "Select Subjects for $className",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  selectedColor: Colors.black,
                                  cancelText: const Text(
                                    "CANCEL",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  confirmText: const Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  checkColor: Colors.white,
                                  onConfirm: (results) {
                                    setState(() {
                                      selectedSubjects[className] = results;
                                    });
                                  },
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.white,
                                ),
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    hintText: "Class Teacher",
                                    labelText:
                                        "Select Section For Class Teacher",
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Appcolors.appLightBlue,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                  ),
                                  value: selectedClassTeacher.isEmpty
                                      ? null
                                      : selectedClassTeacher,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedClassTeacher = newValue!;
                                    });
                                  },
                                  items: selectedClasses
                                      .map<DropdownMenuItem<String>>(
                                          (String className) {
                                    return DropdownMenuItem<String>(
                                      value: className,
                                      child: Text(className),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              child: CustomBlueButton(
                                buttonText: 'Add',
                                onPressed: () async {
                                  Database_Service.saveTeacher(schoolId, empIDController.text,
                                      nameController.text, selectedGender, phoneNoController.text,
                                      cnicController.text, fatherNameController.text, selectedClasses,
                                      selectedSubjects, selectedClassTeacher);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Appcolors.appLightBlue),
                                        ),
                                      );
                                    },
                                  );

                                  Navigator.of(context).pop();
                                },
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
      ),
    );
  }
}
