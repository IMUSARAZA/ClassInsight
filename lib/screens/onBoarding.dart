// ignore_for_file: must_be_immutable

import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/models/SchoolModel.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:classinsight/Widgets/onBoardDropDown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widgets/BaseScreen.dart';


class SchoolController extends GetxController {
  var schools = <School>[].obs;
  var school = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getSchools();
  }

  void getSchools() async {
    var fetchedSchools = await Database_Service.getAllSchools();
    schools.assignAll(fetchedSchools);
  }

  void setSchool(String value) {
    school.value = value;
  }

  String getSchool() {
    return school.value;
  }
}





class OnBoarding extends StatelessWidget {
  OnBoarding({Key? key}) : super(key: key);

  final SchoolController schoolController = Get.put(SchoolController());

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: BaseScreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Class Insights",
              style: Font_Styles.largeHeadingBold(context),
            ),
            Text(
              "A School Management System",
              style: Font_Styles.labelHeadingLight(context),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              "Choose your Institute",
              style: Font_Styles.labelHeadingLight(context),
            ),
            SizedBox(height: screenHeight * 0.01),
            Obx(() {
              if (schoolController.schools.isEmpty) {
                return CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else {
                return OnBoardDropDown(
                  items: schoolController.schools,
                  onChanged: (item) {
                    print("CLICKED"+item!.schoolId);
                    Get.toNamed("/loginAs", arguments: item);
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
