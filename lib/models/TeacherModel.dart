class Teacher {
  late String empID;
  late String name;
  late String gender;
  late String cnic;
  late String fatherName;
  late List<String> classes;
  late Map<String, List<String>> subjects;
  late String classTeacher;

  Teacher({
    required this.empID,
    required this.name,
    required this.gender,
    required this.cnic,
    required this.fatherName,
    required this.classes,
    required this.subjects,
    required this.classTeacher,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      empID: json['EmployeeID'] ?? '',
      name: json['Name'] ?? '',
      gender: json['Gender'] ?? '',
      cnic: json['CNIC'] ?? '',
      fatherName: json['FatherName'] ?? '',
      classes: List<String>.from(json['Classes'] ?? []),
      subjects: (json['Subjects'] ?? {}).map<String, List<String>>(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
      classTeacher: json['ClassTeacher'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': empID,
      'Name': name,
      'Gender': gender,
      'CNIC': cnic,
      'FatherName': fatherName,
      'Classes': classes,
      'Subjects': subjects,
      'ClassTeacher': classTeacher,
    };
  }
}
