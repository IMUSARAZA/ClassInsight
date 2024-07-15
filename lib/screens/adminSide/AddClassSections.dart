import 'package:classinsight/utils/fontStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:classinsight/Widgets/CustomTextField.dart';
import 'package:classinsight/utils/AppColors.dart';



class AddClassSectionsController extends GetxController {
  RxnInt selectedSections = RxnInt();
  RxBool textShow = false.obs;
  RxList<bool> isValidList = <bool>[false].obs;
  TextEditingController gradeName = TextEditingController();
  RxList<TextEditingController> sectionControllers = <TextEditingController>[].obs;

  void updateSections(int sections) {
    isValidList.clear();
    sectionControllers.clear();
    for (int i = 0; i < sections; i++) {
      sectionControllers.add(TextEditingController());
      isValidList.add(true);
    }
  }

  bool validateFields() {
    bool isValid = true;
    for (int i = 0; i < sectionControllers.length; i++) {
      if (sectionControllers[i].text.trim().isEmpty) {
        isValid = false;
        isValidList[i] = false;
      } else {
        isValidList[i] = true;
      }
    }
    update();
    return isValid;
  }

  List<String> collectFormValues() {
    List<String> formData = [];

    String gradeNameValue = gradeName.text.trim();
    if (gradeNameValue.isNotEmpty && selectedSections.value != null) {
      for (int i = 0; i < selectedSections.value!; i++) {
        String sectionValue = sectionControllers[i].text.trim();
        if (sectionValue.isNotEmpty) {
          formData.add('$gradeNameValue-$sectionValue');
        }
      }
    }

    return formData;
  }
}


class AddClassSections extends StatelessWidget {
  AddClassSections({Key? key}) : super(key: key);

  final AddClassSectionsController controller = Get.put(AddClassSectionsController());

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
                  height: screenHeight * 0.20,
                  width: screenWidth,
                  child: AppBar(
                    backgroundColor: AppColors.appLightBlue,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    title: Text(
                      'Classes and Sections',
                      style: Font_Styles.labelHeadingLight(context),
                    ),
                    centerTitle: true,
                    actions: <Widget>[
                      Container(
                        width: 48.0, // Adjust as needed
                      ),
                      TextButton(
                        onPressed: () {
                          if (controller.validateFields()) {
                            List<String> formData = controller.collectFormValues();
                            print(formData);
                            Get.toNamed("/AddSubjects",arguments: formData);
                            // Add your logic to save formData or proceed further
                          } else {
                            Get.snackbar("Invalid Input", "Check whether all the inputs are filled with correct data");
                          }
                        },
                        child: Text(
                          "Add",
                          style: Font_Styles.labelHeadingLight(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.05 * screenHeight,
                  width: screenWidth,
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Add Class and Section',
                    textAlign: TextAlign.center,
                    style: Font_Styles.cardLabel(context),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                            child: CustomTextField(
                              controller: controller.gradeName,
                              hintText: 'Enter the Grade/Class Name',
                              labelText: 'Class Name',
                              isValid: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Number of Sections',
                                  style: Font_Styles.labelHeadingLight(context),
                                ),
                                Obx(
                                  () => DropdownButton<int>(
                                    hint: Text('Select'),
                                    value: controller.selectedSections.value,
                                    items: List.generate(5, (index) => index + 1)
                                        .map((e) => DropdownMenuItem<int>(
                                              value: e,
                                              child: Text(e.toString()),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      controller.textShow.value = true;
                                      if (value != null) {
                                        controller.selectedSections.value = value;
                                        controller.updateSections(value);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => controller.textShow.value
                                ? Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    child: Text("Add name of sections (e.g: alphabets or colors)"),
                                  )
                                : Center(
                                    child: Text("No Sections added", style: Font_Styles.labelHeadingLight(context)),
                                  ),
                          ),
                          Obx(
                            () => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: controller.selectedSections.value != null
                                    ? List.generate(
                                        controller.selectedSections.value!,
                                        (index) => Padding(
                                          padding: const EdgeInsets.only(bottom: 20.0),
                                          child: CustomTextField(
                                            controller: controller.sectionControllers[index],
                                            hintText: 'Enter Section Name ${index + 1}',
                                            labelText: 'Section Name ${index + 1}',
                                            isValid: true,
                                          ),
                                        ),
                                      )
                                    : [],
                              ),
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
    );
  }
}
