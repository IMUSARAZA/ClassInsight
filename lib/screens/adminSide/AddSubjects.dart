import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSubjectsController extends GetxController {
  RxList<String> classes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    classes.value = Get.arguments as List<String> ?? [];
  }
}

class AddSubjects extends StatelessWidget {
  AddSubjects({Key? key}) : super(key: key);

  final AddSubjectsController controller = Get.put(AddSubjectsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes List'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.classes.length,
          itemBuilder: (context, index) {
            var item = controller.classes[index];
            return ListTile(
              title: Text(item),
            );
          },
        ),
      ),
    );
  }
}
