// ignore_for_file: prefer_const_constructors

import 'package:classinsight/screens/adminSide/ManageStudents.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubjectResult extends StatefulWidget {
  const SubjectResult({super.key});

  @override
  State<SubjectResult> createState() => _SubjectResultState();
}

class _SubjectResultState extends State<SubjectResult> {

  double resultFontSize = 16;
  double headingFontSize = 33;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

     if (screenWidth < 350) {
      resultFontSize = 14;
      headingFontSize = 25;
    }
    if (screenWidth < 300) {
      resultFontSize = 14;
      headingFontSize = 23;
    }
    if (screenWidth < 250) {
      resultFontSize = 11;
      headingFontSize = 20;
    }
    if (screenWidth < 230) {
      resultFontSize = 8;
      headingFontSize = 17;
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.10,
                    width: screenWidth,
                    child: AppBar(
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageStudents()),
                          );
                        },
                      ),
                      title: Center(
                        child: Text(
                          'Marks',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: resultFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        Container(
                          width: 48.0, // Adjust as needed
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.05 * screenHeight,
                    width: screenWidth,
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Marks',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: headingFontSize,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}