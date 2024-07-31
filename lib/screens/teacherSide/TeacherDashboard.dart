import 'package:classinsight/Services/Auth_Service.dart';
import 'package:classinsight/models/TeacherModel.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherDashboardController extends GetxController {
  RxInt height = 120.obs;
  late Teacher teacher; 
  final arguments = Get.arguments as List;


  var classesList = <String>[].obs;
  var selectedClass = ''.obs;
  var schoolId;

  @override
  void onInit() {
    super.onInit();
    teacher = arguments[0] as Teacher; 
    schoolId = arguments[1] as String; 
    fetchClasses();
  }

  void fetchClasses() {
    classesList.value = teacher.classes;
    if (classesList.isNotEmpty && selectedClass.isEmpty) {
      selectedClass.value = classesList.first;
    }
  }
}

class TeacherDashboard extends StatelessWidget {
  TeacherDashboard({super.key});

  final TeacherDashboardController _controller = Get.put(TeacherDashboardController());

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 350 && screenWidth <= 400) {
      _controller.height.value = 135;
    } else if (screenWidth > 400 && screenWidth <= 500) {
      _controller.height.value = 160;
    } else if (screenWidth > 500 && screenWidth <= 768) {
      _controller.height.value = 220;
    } else if (screenWidth > 768) {
      _controller.height.value = 270;
    }

    return Scaffold(
      backgroundColor: AppColors.appLightBlue,
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: Font_Styles.labelHeadingLight(context),
        ),
        backgroundColor: AppColors.appLightBlue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Auth_Service.logout(context);
            },
            icon: Icon(Icons.logout_rounded, color: Colors.black),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Hi, ${_controller.teacher.name}",
                  style: Font_Styles.largeHeadingBold(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  _controller.teacher.email,
                  style: Font_Styles.labelHeadingRegular(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  'Class Teacher: ${_controller.teacher.classTeacher}',
                  style: Font_Styles.labelHeadingLight(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  _controller.teacher.subjects.toString(),
                  style: Font_Styles.labelHeadingLight(context),
                ),
              ),
              Expanded(
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.82,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Obx(
                            () => Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 15),
                              child: DropdownButtonFormField<String>(
                                value: _controller.selectedClass.value,
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
                                        color: AppColors.appLightBlue, width: 2.0),
                                  ),
                                ),
                                items: _controller.classesList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  _controller.selectedClass.value = newValue ?? '';
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.01),

                          Center(
                            child: GestureDetector(
                              onTap: () {
                               Get.toNamed("/MarkAttendance",arguments: [_controller.schoolId,_controller.selectedClass]);
                              },
                              child: Container(
                                height: screenHeight * 0.16,
                                width: screenWidth-100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: AppColors.appDarkBlue,
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                ),
                                
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                                                
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Icon(Icons.people, size: 50, color: AppColors.appDarkBlue),
                                    ),
                                                                
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Text(
                                        'Attendance',
                                        style: Font_Styles.cardLabel(context, color:AppColors.appLightBlue)
                                      ),
                                    ),
                                  ],),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // Get.toNamed('/teacherClass',
                                //     arguments: _controller.selectedClass.value);
                              },
                              child: Container(
                                height: screenHeight * 0.16,
                                width: screenWidth-100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: AppColors.appOrange,
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                ),
                                
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                                                
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Icon(Icons.book, size: 50, color: AppColors.appOrange),
                                    ),
                                                                
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Text(
                                        'Marks',
                                        style: TextStyle(
                                          color: AppColors.appOrange,
                                          fontSize: 20, // Adjust as needed
                                        ),
                                      ),
                                    ),
                                  ],),
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
            ],
          ),
        ],
      ),
    );
  }
}
