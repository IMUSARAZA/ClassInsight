import 'package:classinsight/firebase_options.dart';
import 'package:classinsight/routes/mainRoutes.dart';
import 'package:classinsight/screens/adminSide/AddTimetable.dart';
import 'package:classinsight/screens/adminSide/ManageTimetable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  } catch (e) {
  print(e.toString());
  }
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  User? user;


   @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      // initialRoute:_getInitialLocation(user),
      // getPages: MainRoutes.routes,
      home: AddTimetable(),
    );
  }


  String _getInitialLocation(User? user) {
    if (user != null) {
      if (user.email!=null) {
        return '/AdminHome';
      } else {
        return '/';
      }
    } else {
      return '/onBoarding';
    }
  }
}

