// ignore_for_file: must_be_immutable

import 'package:classinsight/screens/adminSide/ManageTeachers.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/Widgets/CustomBlueButton.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddTeacherController extends GetxController {
  TextEditingController empIDController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  var empIDValid = true.obs;
  var nameValid = true.obs;
  var genderValid = true.obs;
  var cnicValid = true.obs;
  var fatherNameValid = true.obs;
  var phoneNoValid = true.obs;

  var selectedGender = ''.obs;
  var selectedClass = ''.obs;
  var selectedClassTeacher = ''.obs;
  var addStdFontSize = 16.0;
  var headingFontSize = 33.0;

  RxList<String> selectedClasses = <String>[].obs;
  RxList<ClassSubject> classesSubjects = <ClassSubject>[].obs;
  RxMap<String, List<String>> selectedSubjects = <String, List<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClassesAndSubjects();
  }

  String schoolId = 'buwF2J4lkLCdIVrHfgkP';

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

    classesSubjects.assignAll(fetchedClassesSubjects);
  }
}

class ClassSubject {
  String className;
  List<String> subjects;

  ClassSubject({required this.className, required this.subjects});
}

class AddTeacher extends StatelessWidget {
  final AddTeacherController controller = Get.put(AddTeacherController());
  double addStdFontSize = 16;
  double headingFontSize = 33;

  AddTeacher({Key? key}) : super(key: key);

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.appLightBlue,
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
                      backgroundColor: AppColors.appLightBlue,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageTeachers()),
                          );
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
                              padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                              child: CustomTextField(
                                controller: controller.empIDController,
                                hintText: 'Employee ID',
                                labelText: 'Employee ID',
                                isValid: controller.empIDValid.value,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: controller.nameController,
                                hintText: 'Name',
                                labelText: 'Name',
                                isValid: controller.nameValid.value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.white,
                                ),
                                child:
                                    Obx(() => DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            hintText: "Select your gender",
                                            labelText: "Gender",
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: AppColors.appLightBlue,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.0),
                                            ),
                                          ),
                                          value: controller
                                                  .selectedGender.value.isEmpty
                                              ? null
                                              : controller.selectedGender.value,
                                          onChanged: (newValue) {
                                            controller.selectedGender.value =
                                                newValue!;
                                          },
                                          items: <String>[
                                            'Male',
                                            'Female',
                                            'Other'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: controller.cnicController,
                                hintText: '352020xxxxxxxx91',
                                labelText: 'CNIC No',
                                isValid: controller.cnicValid.value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: controller.phoneNoController,
                                hintText: '0321xxxxxx12',
                                labelText: 'Phone Number',
                                isValid: controller.phoneNoValid.value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: CustomTextField(
                                controller: controller.fatherNameController,
                                hintText: "Father's name",
                                labelText: "Father's name",
                                isValid: controller.fatherNameValid.value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: Obx(() => MultiSelectDialogField(
                                    backgroundColor: AppColors.appLightBlue,
                                    items: controller.classesSubjects
                                        .map((classSubject) => MultiSelectItem(
                                            classSubject.className,
                                            classSubject.className))
                                        .toList(),
                                    title: const Text("Available Classes"),
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
                                      controller.selectedClasses
                                          .assignAll(results);
                                    },
                                  )),
                            ),
                            Obx(() => Column(
                                  children: [
                                    for (var className
                                        in controller.selectedClasses)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 0, 30, 20),
                                        child: MultiSelectDialogField(
                                          backgroundColor:
                                              AppColors.appLightBlue,
                                          items: controller.classesSubjects
                                              .firstWhere((classSubject) =>
                                                  classSubject.className ==
                                                  className)
                                              .subjects
                                              .map((subject) => MultiSelectItem(
                                                  subject, subject))
                                              .toList(),
                                          title:
                                              Text("Subjects for $className"),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                            controller.selectedSubjects[
                                                className] = results;
                                          },
                                        ),
                                      ),
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                              child: Obx(() => DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      hintText: "Class Teacher",
                                      labelText:
                                          "Select Section For Class Teacher",
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: AppColors.appLightBlue,
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0),
                                      ),
                                    ),
                                    value: controller
                                            .selectedClassTeacher.value.isEmpty
                                        ? null
                                        : controller.selectedClassTeacher.value,
                                    onChanged: (newValue) {
                                      controller.selectedClassTeacher.value =
                                          newValue!;
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: '',
                                        child: Text('None'),
                                      ),
                                      ...controller.selectedClasses
                                          .map<DropdownMenuItem<String>>(
                                              (String className) {
                                        return DropdownMenuItem<String>(
                                          value: className,
                                          child: Text(className),
                                        );
                                      }).toList(),
                                    ],
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              child: CustomBlueButton(
                                buttonText: 'Add',
                                onPressed: () async {
                                  if (controller.selectedClasses.isEmpty &&
                                      controller.selectedSubjects.isEmpty &&
                                      controller
                                          .selectedClassTeacher.value.isEmpty &&
                                      controller.empIDController.text.isEmpty &&
                                      controller.nameController.text.isEmpty &&
                                      controller.selectedGender.value.isEmpty &&
                                      controller
                                          .phoneNoController.text.isEmpty &&
                                      controller.cnicController.text.isEmpty &&
                                      controller
                                          .fatherNameController.text.isEmpty) {
                                    Get.snackbar(
                                        'Error', 'Please fill all the fields');
                                  } else {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppColors.appLightBlue),
                                          ),
                                        );
                                      },
                                    );

                                    try {
                                      await Database_Service.saveTeacher(
                                        controller.schoolId,
                                        controller.empIDController.text,
                                        controller.nameController.text,
                                        controller.selectedGender.value,
                                        controller.phoneNoController.text,
                                        controller.cnicController.text,
                                        controller.fatherNameController.text,
                                        controller.selectedClasses.toList(),
                                        controller.selectedSubjects.toJson(),
                                        controller.selectedClassTeacher.value,
                                      );

                                      Navigator.of(context).pop();
                                    } catch (e) {
                                      Navigator.of(context).pop();
                                      print('Error saving teacher: $e');
                                    }
                                  }
                                }, text: 'Add',
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
