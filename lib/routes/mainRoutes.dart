import 'package:classinsight/screens/adminSide/AddClassSections.dart';
import 'package:classinsight/screens/adminSide/AddExamSystem.dart';
import 'package:classinsight/screens/adminSide/AddStudent.dart';
import 'package:classinsight/screens/LoginAs.dart';
import 'package:classinsight/screens/adminSide/AddSubjects.dart';
import 'package:classinsight/screens/adminSide/AddTeacher.dart';
import 'package:classinsight/screens/adminSide/AdminHome.dart';
import 'package:classinsight/screens/adminSide/ClassSections.dart';
import 'package:classinsight/screens/adminSide/EditStudent.dart';
import 'package:classinsight/screens/adminSide/EditTeacher.dart';
import 'package:classinsight/screens/adminSide/LoginScreen.dart';
import 'package:classinsight/screens/adminSide/MakeAnnouncements.dart';
import 'package:classinsight/screens/adminSide/ManageStudents.dart';
import 'package:classinsight/screens/adminSide/ManageTeachers.dart';
import 'package:classinsight/screens/adminSide/StudentResult.dart';
import 'package:classinsight/screens/onBoarding.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class MainRoutes{
   static List<GetPage> routes = [
    GetPage(
      name: "/onBoarding",
      page: () => OnBoarding(),
    ),
    GetPage(
      name: "/loginAs",
      page: () => LoginAs(),
    ),
    GetPage(
      name: "/AddStudent",
      page: () => const AddStudent(),
    ),
    GetPage(
      name: "/ManageStudents",
      page: () => const ManageStudents(),
    ),
    GetPage(
      name: "/LoginScreen",
      page: () => LoginScreen(),
    ),
    GetPage(
      name: "/AdminHome",
      page: () => AdminHome(),
    ),
    GetPage(
      name: "/EditStudent",
      page: () => const EditStudent(),
    ),
    GetPage(
      name: "/ClassSections",
      page: () => const ClassSections(),
    ),
    GetPage(
      name: "/AddClassSections",
      page: () => AddClassSections(),
    ),
    GetPage(
      name: "/AddSubjects",
      page: () => AddSubjects(),
    ),
    GetPage(
      name: "/AddExamSystem",
      page: () => AddExamSystem(),
    ),
    GetPage(
      name: "/ManageTeachers",
      page: () => const ManageTeachers(),
    ),
    GetPage(
      name: "/AddTeacher",
      page: () => AddTeacher(),
    ),
    GetPage(
      name: "/EditTeacher",
      page: () => EditTeacher(),
    ),
    GetPage(
      name: "/StudentResult",
      page: () => const StudentResult(),
    ),
    GetPage(
      name: "/MakeAnnouncements",
      page: () => MakeAnnouncements(),
    ),
  ];
}