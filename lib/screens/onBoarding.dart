import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/models/SchoolModel.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:classinsight/widgets/onBoardDropDown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/BaseScreen.dart';

class SchoolController extends GetxController {
  var school = ''.obs;

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
  List<School> schools = [];

  void getSchools() async {
    schools = await Database_Service.getAllSchools();
    Get.forceAppUpdate();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    getSchools();

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
            // Display dropdown only if schools are fetched
              OnBoardDropDown(
                items: schools,
                onChanged: (item) {
                  Get.toNamed("/loginAs", arguments: item);
                },
              ),
          ],
        ),
      ),
    );
  }
}
