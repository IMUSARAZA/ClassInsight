// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:classinsight/screens/onBoarding.dart';
import 'package:classinsight/services/Auth_Service.dart';
import 'package:classinsight/utils/AppColors.dart';
import 'package:classinsight/utils/fontStyles.dart';
import 'package:classinsight/widgets/shadowButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  var email = 'test@gmail.com'.obs;
  RxString totalStudents= '24'.obs;
  RxString totalTeachers= '24'.obs;
  RxInt height = 120.obs;

  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments?['email'] ?? '';
  }
}

class AdminHome extends StatelessWidget {
  AdminHome({super.key});
  final AdminHomeController _controller = Get.put(AdminHomeController());
  final SchoolController schoolController = Get.put(SchoolController());


  @override
  Widget build(BuildContext context) {
    double screenHeight =  MediaQuery.of(context).size.height;
    double screenWidth =  MediaQuery.of(context).size.width;

    if(screenWidth>350 && screenWidth<=400){
      _controller.height.value = 135;
    }
    else if(screenWidth>400 && screenWidth<=500){
     _controller.height.value = 160;
    }
    else if(screenWidth>500 && screenWidth<=768){
      _controller.height.value = 220;
    }
    else if(screenWidth>768){
      _controller.height.value = 270;

    }



    return Scaffold(
      backgroundColor: AppColors.appLightBlue,
      appBar: AppBar(
        title: Text("Dashboard", style: Font_Styles.labelHeadingLight(context),),
        backgroundColor: AppColors.appLightBlue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              Auth_Service.logout(context);
          }, 
          icon: Icon(Icons.logout_rounded,color: Colors.black,)
          )
        ],
      ),

      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Hi, Admin", style: Font_Styles.largeHeadingBold(context)),
              ),
              Obx(() => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_controller.email.value, style: Font_Styles.labelHeadingRegular(context)),
                  )),
              Obx(() => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(schoolController.getSchool() ?? "", style: Font_Styles.labelHeadingLight(context)),
                  )),
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
                        horizontal: screenWidth*0.05,
                        vertical: screenHeight*0.05
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                },
                                child: Container(
                                  width: screenWidth*0.4,
                                  height: _controller.height.value.toDouble(),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.appLightBlue,
                                      border: Border.all(color: Colors.black)
                                    ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth*0.01,
                                        vertical: screenHeight*0.01
                                      ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      Icon(FontAwesomeIcons.userGraduate),
                                       Obx((){
                                         return Text(
                                          _controller.totalStudents.value,
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: Font_Styles.mediumHeadingBold(context),
                                          );
                                       }) ,
                                        Text(
                                          "Total Students Registered",
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: Font_Styles.labelHeadingRegular(context),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: (){

                                },
                                child: Container(
                                  width: screenWidth*0.4,
                                  height: _controller.height.value.toDouble(),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.appLightBlue,
                                      border: Border.all(color: Colors.black)
                                    ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth*0.01,
                                        vertical: screenHeight*0.01
                                      ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      Icon(FontAwesomeIcons.graduationCap),
                                       Obx((){
                                         return Text(
                                          _controller.totalTeachers.value,
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: Font_Styles.mediumHeadingBold(context),
                                          );
                                       }) ,
                                        Text(
                                          "Total Teachers Registered",
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: Font_Styles.labelHeadingRegular(context),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(children: [
                            ShadowButton(
                              text: "Manage Students", 
                              onTap:(){
                                  Get.toNamed("/ManageStudents");
                                }, ),
                                Spacer(),
                            ShadowButton(
                              text: "Manage Teachers", 
                              onTap:(){
                                  Get.toNamed("/ManageTeachers");
                                }, ),
                          ],),
                          SizedBox(height: 20,),

                          Row(children: [
                            ShadowButton(
                              text: "Manage Timetable", 
                              onTap:(){
                                  Get.toNamed("/ManageTimetable");
                                }, ),
                                Spacer(),
                            ShadowButton(
                              text: "Make Announcements", 
                              onTap:(){
                                  Get.toNamed("/MakeAnnouncements");
                                }, ),
                          ],),
                          SizedBox(height: 20,),

                          Row(children: [
                            ShadowButton(
                              text: "Classes, Sections and Subjects", 
                              onTap:(){
                                  Get.toNamed("/ManageClass");
                                }, ),
                                Spacer(),
                            ShadowButton(
                              text: "Promote Students", 
                              onTap:(){
                                  Get.toNamed("/PromoteStudents");
                                }, ),
                          ],),
                          SizedBox(height: 20,),
                          ShadowButton(
                              text: "Results", 
                              onTap:(){
                                  Get.toNamed("/Results");
                                }, ),
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