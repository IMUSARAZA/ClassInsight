import 'package:classinsight/Services/Auth_Service.dart';
import 'package:classinsight/models/TeacherModel.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class TeacherDashboardController extends GetxController {

RxInt height = 120.obs;
Teacher? teacher;

@override
  void onInit() {
    // teacher = 
    super.onInit();
  }


  void getTeacherData() async {
    // teacher = await Auth_Service.registerTeacher(email, password, schoolId)
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
              // _controller.clearCachedSchoolData();
            },
            icon: Icon(Icons.logout_rounded, color: Colors.black),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical:8
                ),
                child: Text(
                  "Hi, Teacher",
                  style: Font_Styles.largeHeadingBold(context),
                ),
              ),
              // Obx(
              //   () => Padding(
              //     padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //     vertical:8
              //   ),
              //     child: Text(
              //       _controller.email.value,
              //       style: Font_Styles.labelHeadingRegular(context),
              //     ),
              //   ),
              // ),
              // Obx(
              //   () => Padding(
              //     padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //     vertical:10
              //   ),
              //     child: Text(
              //       _controller.schoolName.value,
              //       style: Font_Styles.labelHeadingLight(context),
              //     ),
              //   ),
              // ),
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
                        children: [




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
