import 'package:flutter/material.dart';

void main() {
  runApp(ManageStudents());
}

class ManageStudents extends StatelessWidget {
  const ManageStudents({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double addStdFontSize = 16;
    double studentsFontSize = 25;
    double classFontSize = 15;

    if (screenWidth < 300) {
      addStdFontSize = 14;
      studentsFontSize = 20;
      classFontSize = 12;
    }
    if (screenWidth < 250) {
      addStdFontSize = 11;
      studentsFontSize = 15;
      classFontSize = 10;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.grey,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'Add Student',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: addStdFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Text(
                  'Students',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: studentsFontSize,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Text(
                  'Class',
                  style:
                      TextStyle(color: Colors.black, fontSize: classFontSize),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: DropdownButtonFormField<String>(
                  value: '2A',
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  items: <String>['2A', '1C', '3B', '3D', '4A']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle change here
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Text(
                  'Search',
                  style:
                      TextStyle(color: Colors.black, fontSize: classFontSize),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Student', // Placeholder text
                    hintStyle: TextStyle(
                        color: Colors.grey), // Style for the placeholder
                    labelText: 'Student', // Label for the text field
                    labelStyle:
                        TextStyle(color: Colors.black), // Style for the label
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10), // Padding inside the text field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.black), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 1), // Border color and width when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors.grey), // Border color when enabled
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
