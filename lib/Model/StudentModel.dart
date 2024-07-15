class Student {
  late String name;
  late String gender;
  late String bForm_challanId;
  late String fatherName;
  late String fatherPhoneNo;
  late String fatherCNIC;
  late String studentRollNo;
  late String studentID;
  late String classSection;

  Student({
    required this.name,
    required this.gender,
    required this.bForm_challanId,
    required this.fatherName,
    required this.fatherPhoneNo,
    required this.fatherCNIC,
    required this.studentRollNo,
    required this.studentID,
    required this.classSection,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['Name'] ?? '',
      gender: json['Gender'] ?? '',
      bForm_challanId: json['BForm_challanId'] ?? '',
      fatherName: json['FatherName'] ?? '',
      fatherPhoneNo: json['FatherPhoneNo'] ?? '',
      fatherCNIC: json['FatherCNIC'] ?? '',
      studentRollNo: json['StudentRollNo'] ?? '',
      studentID: json['StudentID'] ?? '',
      classSection: json['ClassSection'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Gender': gender,
      'BForm_challanId': bForm_challanId,
      'FatherName': fatherName,
      'FatherPhoneNo': fatherPhoneNo,
      'FatherCNIC': fatherCNIC,
      'StudentRollNo': studentRollNo,
      'StudentID': studentID,
      'ClassSection': classSection,
    };
  }
}
