import 'package:classinsight/Services/Database_Service.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MakeAnnouncementsController extends GetxController {
  TextEditingController announcementController = TextEditingController();
  AdminHomeController school = Get.put(AdminHomeController());

  var announcementValid = true.obs;
  var addStdFontSize = 16.0;
  var headingFontSize = 33.0;
}

class MakeAnnouncements extends StatelessWidget {
  MakeAnnouncements({Key? key}) : super(key: key);

  final MakeAnnouncementsController controller =
      Get.put(MakeAnnouncementsController());

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
                    actions: <Widget>[
                      Container(
                        width: 48.0,
                      ),
                      TextButton(
                        onPressed: () {
                          // Save the changes to the database

                          // Navigate back or show a success message
                          if(controller.announcementController.text.isEmpty){
                            Get.snackbar(
                              'Empty Announcement',
                              'Please write an announcement before sending it.',
                            );
                            return;
                          }else{

                          Database_Service.createAnnouncement(controller.school.schoolId.value, '', controller.announcementController.text, 'Admin', true);

                          Get.snackbar(
                            'Announcement Sent',
                            'The announement has been successfully sent to all the school.',
                          );
                        }
                        },
                        child: Text(
                          "Send",
                          style: Font_Styles.labelHeadingLight(context),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0, screenHeight * 0.18, 0, 0),
                  child: Center(
                    child: Text(
                      "Make Announcement",
                      style: Font_Styles.largeHeadingBold(context),
                    ),
                  ),
                ),

                Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05,
                      screenHeight * 0.05, screenWidth * 0.05, 0),
                  child: Container(
                    height: screenHeight * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: controller.announcementController,
                      decoration: const InputDecoration(
                        hintText: 'Type your announcement here......', 
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      ),
                      style: const TextStyle(color: Colors.black),
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
