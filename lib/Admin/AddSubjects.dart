import 'package:classinsight/Const/AppColors.dart';
import 'package:classinsight/Widgets/CustomBlueButton.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const AddSubjects());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class AddSubjects extends StatefulWidget {
  const AddSubjects({super.key});

  @override
  State<AddSubjects> createState() => _AddSubjectsState();
}

class _AddSubjectsState extends State<AddSubjects> {
  double addStdFontSize = 16;
  double headingFontSize = 33;
  List<String> subjects = [];
  TextEditingController subjectsController = TextEditingController();
  bool subjectsValid = true;

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 350) {
      addStdFontSize = 14;
      headingFontSize = 27;
    }
    if (screenWidth < 300) {
      addStdFontSize = 14;
      headingFontSize = 24;
    }
    if (screenWidth < 250) {
      addStdFontSize = 11;
      headingFontSize = 20;
    }
    if (screenWidth < 230) {
      addStdFontSize = 8;
      headingFontSize = 15;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Appcolors.appLightBlue,
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
  backgroundColor: Appcolors.appLightBlue,
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.of(context).pop();
    },
  ),
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Spacer(),  // To push the title to the center
      Text(
        'Add Subjects',
        style: TextStyle(
          color: Colors.black,
          fontSize: addStdFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      Spacer(),  // To push the title to the center
    ],
  ),
  actions: <Widget>[
    TextButton(
      onPressed: () {
        // Implement your save logic here
      },
      child: Text(
        'Save',
        style: TextStyle(
          color: Colors.black,
          fontSize: addStdFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Container(
      width: 16.0, // Adjusted for better spacing
    ),
  ],
),



                  ),
                  Container(
                    height: 0.05 * screenHeight,
                    width: screenWidth,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Add New Subjects',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: headingFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                              child: CustomTextField(
                                controller: subjectsController,
                                hintText: 'e.g Physics',
                                labelText: 'Add Subjects',
                                isValid: subjectsValid,
                              ),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: subjects.map((subject) {
                                  return Chip(
                                    label: Text(subject),
                                    deleteIcon: Icon(Icons.close),
                                    onDeleted: () {
                                      setState(() {
                                        subjects.remove(subject);
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, screenHeight*0.5, 30, 0),
                              child: CustomBlueButton(
                                buttonText: 'Add',
                                onPressed: () {
                                  setState(() {
                                    if (subjectsController.text.isNotEmpty) {
                                      subjects.add(subjectsController.text);
                                      subjectsController.clear();
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
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
    );
  }
}
