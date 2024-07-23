import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/models/TeacherModel.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class ClassSubject {
  String className;
  List<String> subjects;

  ClassSubject({required this.className, required this.subjects});
}

class EditTeacherController extends GetxController {
  String changedGender = '';
  String changedClassTeacher = '';
  Map<String, List<String>> subjects = {};
  List<String> existingClasses = [];
  Map<String, List<String>> existingSubjects = {};
  RxList<ClassSubject> classesSubjects = <ClassSubject>[].obs;
  RxList<String> selectedClasses = <String>[].obs;
  RxMap<String, List<String>> selectedSubjects = <String, List<String>>{}.obs;
  RxString name = 'Initial Name'.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController updatedController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  var genderValid = true.obs;
  var cnicValid = true.obs;
  var nameValid = true.obs;
  var fatherNameValid = true.obs;
  var phoneNoValid = true.obs;
  AdminHomeController school = Get.put(AdminHomeController());
  RxString schoolId = ''.obs;
  var selectedGender = ''.obs;
  var selectedClassTeacher = ''.obs;
  var existingClassTeacher = ''.obs;
  Teacher? teacher;
  var addStdFontSize = 16.0;
  var headingFontSize = 33.0;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    teacher = Get.arguments;
    schoolId.value = school.schoolId.value;
    initializeData(teacher!);
    fetchClassesAndSubjects();
  }


  void fetchClassesAndSubjects() async {
    isLoading.value = true;
    List<String> classesFetched = await Database_Service.fetchClasses(schoolId.value);
    List<ClassSubject> fetchedClassesSubjects = [];

    for (String className in classesFetched) {
      List<String> subjects =
          await Database_Service.fetchSubjects(schoolId.value, className);
      fetchedClassesSubjects
          .add(ClassSubject(className: className, subjects: subjects));
    }

    classesSubjects.assignAll(fetchedClassesSubjects);
    isLoading.value = false;
  }

  void initializeData(Teacher teacher) {
    name.value = teacher.name;
    updatedController.text = teacher.name;
    cnicController.text = teacher.cnic;
    phoneNoController.text = teacher.phoneNo;
    fatherNameController.text = teacher.fatherName;
    selectedGender.value = teacher.gender;
    existingClassTeacher.value = teacher.classTeacher;
    selectedClassTeacher.value = teacher.classTeacher;
    existingClasses = teacher.classes;
    existingSubjects = teacher.subjects;
    selectedClasses.assignAll(teacher.classes);
    selectedSubjects.assignAll(teacher.subjects);
  }

  void showEditNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          backgroundColor: AppColors.appLightBlue,
          content: TextField(
            controller: updatedController,
            decoration: const InputDecoration(
              hintText: 'Enter new name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                print(updatedController.text);
                name.value = updatedController.text;
                Navigator.of(context).pop();
              },
              child: const Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}

class EditTeacher extends StatelessWidget {
  EditTeacher({Key? key}) : super(key: key);

  final EditTeacherController controller = Get.put(EditTeacherController());

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 350) {
      controller.addStdFontSize = 14.0;
      controller.headingFontSize = 27.0;
    }
    if (screenWidth < 300) {
      controller.addStdFontSize = 14.0;
      controller.headingFontSize = 24.0;
    }
    if (screenWidth < 250) {
      controller.addStdFontSize = 11.0;
      controller.headingFontSize = 20.0;
    }
    if (screenWidth < 230) {
      controller.addStdFontSize = 8.0;
      controller.headingFontSize = 15.0;
    }

    return Scaffold(
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
                          if (
                            controller.selectedGender.value.isEmpty ||
                            controller.phoneNoController.text.isEmpty ||
                            controller.cnicController.text.isEmpty ||
                            controller.fatherNameController.text.isEmpty ||
                            controller.selectedClasses.isEmpty ||
                            controller.selectedSubjects.isEmpty
                              ) {
                            Get.snackbar('No Changes Made',
                                'Please make some changes to update the teacher');
                          } 

                          else {
                        print(controller.selectedClassTeacher.value);

                            Database_Service.updateTeacher(
                                controller.schoolId.value,
                                controller.teacher!.empID,
                                controller.name.value,
                                controller.selectedGender.value,
                                controller.phoneNoController.text,
                                controller.cnicController.text,
                                controller.fatherNameController.text,
                                controller.selectedClasses,
                                controller.selectedSubjects,
                                controller.selectedClassTeacher.value);

                            Get.snackbar('Teacher Updated',
                                'The teacher has been updated successfully');
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          "Update",
                          style: Font_Styles.labelHeadingLight(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, screenHeight * 0.03),
                  child: Container(
                    height: 0.05 * screenHeight,
                    width: screenWidth,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Edit Teacher',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: controller.headingFontSize,
                        fontWeight: FontWeight.w700,
                      ),
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
                            padding: EdgeInsets.fromLTRB(
                                0, screenHeight * 0.03, 0, screenHeight * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 20, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Obx(() => Text(
                                              controller.name.value,
                                              style: TextStyle(
                                                fontSize:
                                                    controller.headingFontSize -
                                                        10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          controller
                                              .showEditNameDialog(context);
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                  child: Text(
                                    controller.teacher!.empID,
                                    style: TextStyle(
                                      fontSize: controller.addStdFontSize,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                30, 0, 60, screenHeight * 0.01),
                            child: Text(
                              'Classes Teacher: ${controller.teacher!.classTeacher}',
                              style: TextStyle(
                                fontSize: controller.addStdFontSize,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                30, 0, 60, screenHeight * 0.04),
                            child: Text(
                              'Classes & Subjects: ${controller.teacher!.subjects}',
                              style: TextStyle(
                                fontSize: controller.addStdFontSize,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Colors.white,
                              ),
                              child: Obx(
                                () => DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    hintText: "Select your gender",
                                    labelText: "Gender",
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: AppColors.appLightBlue,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                  ),
                                  value: controller.selectedGender.value.isEmpty
                                      ? null
                                      : controller.selectedGender.value,
                                  onChanged: (newValue) {
                                    controller.selectedGender.value = newValue!;
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
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.appDarkBlue),
                                );
                              } else {
                                return Column(
                                  children: [
                                    MultiSelectDialogField(
                                      backgroundColor: AppColors.appLightBlue,
                                      items: controller.classesSubjects
                                          .map((classSubject) =>
                                              MultiSelectItem(
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
                                      initialValue: controller
                                          .selectedClasses,
                                      onConfirm: (results) {
                                        controller.selectedClasses
                                            .assignAll(results);
                                      },
                                    ),
                                    Obx(() => Column(
                                          children: [
                                            for (var className
                                                in controller.selectedClasses)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 20, 0, 20),
                                                child: MultiSelectDialogField(
                                                  backgroundColor:
                                                      AppColors.appLightBlue,
                                                  items: controller
                                                      .classesSubjects
                                                      .firstWhere(
                                                          (classSubject) =>
                                                              classSubject
                                                                  .className ==
                                                              className)
                                                      .subjects
                                                      .map((subject) =>
                                                          MultiSelectItem(
                                                              subject, subject))
                                                      .toList(),
                                                  title: Text(
                                                      "Subjects for $className"),
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
                                                  initialValue: controller
                                                              .selectedSubjects[
                                                          className] ??
                                                      [],
                                                  onConfirm: (results) {
                                                    controller.selectedSubjects[
                                                            className] =
                                                        results
                                                            .map((e) =>
                                                                e.toString())
                                                            .toList();
                                                  },
                                                ),
                                              ),
                                          ],
                                        )),
                                  ],
                                );
                              }
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.appDarkBlue),
                                );
                              } else {
                                final filteredClasses = controller
                                    .classesSubjects
                                    .where((classSubject) => controller
                                        .selectedClasses
                                        .contains(classSubject.className))
                                    .map((classSubject) =>
                                        classSubject.className)
                                    .toList();

                                final items = [
                                  const DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('None'),
                                  ),
                                  ...filteredClasses.map(
                                      (className) => DropdownMenuItem<String>(
                                            value: className,
                                            child: Text(className),
                                          )),
                                ];

                                return DropdownButtonFormField<String>(
                                  value: items
                                          .map((item) => item.value)
                                          .contains(controller
                                              .existingClassTeacher.value)
                                      ? controller.existingClassTeacher.value
                                      : null,
                                  items: items,
                                  onChanged: (newValue) {
          controller.selectedClassTeacher.value = newValue ?? '';
        },
                                  decoration: InputDecoration(
                                    labelText: "Class Teacher",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            }),
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