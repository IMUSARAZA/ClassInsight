import 'package:classinsight/utils/fontStyles.dart';
import 'package:classinsight/widgets/onBoardDropDown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/BaseScreen.dart';

class OnBoarding extends StatelessWidget {
  OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight =  MediaQuery.of(context).size.height;
    double screenWidth =  MediaQuery.of(context).size.width;


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
            onBoardDropDown(
              items: ["Campus 1", "Campus 2"],
              onChanged: (item) {
                Get.toNamed("/loginAs");
              },
            ),
          ],
        ),
      ),
    );
  }
}
