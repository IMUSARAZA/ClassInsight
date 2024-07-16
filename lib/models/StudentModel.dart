import 'package:classinsight/services/database_service.dart';

class Student {
  late String name;
  late String gender;
  late String bFormChallanId;
  late String fatherName;
  late String fatherPhoneNo;
  late String fatherCNIC;
  late String studentRollNo;
  late String studentID;
  late String classSection;
  late Map<String, Map<String, String>> resultMap;

  Student({
    required this.name,
    required this.gender,
    required this.bFormChallanId,
    required this.fatherName,
    required this.fatherPhoneNo,
    required this.fatherCNIC,
    required this.studentRollNo,
    required this.studentID,
    required this.classSection,
    Map<String, Map<String, String>>? resultMap,
  }) : resultMap = resultMap ?? {};

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['Name'] ?? '',
      gender: json['Gender'] ?? '',
      bFormChallanId: json['BForm_challanId'] ?? '',
      fatherName: json['FatherName'] ?? '',
      fatherPhoneNo: json['FatherPhoneNo'] ?? '',
      fatherCNIC: json['FatherCNIC'] ?? '',
      studentRollNo: json['StudentRollNo'] ?? '',
      studentID: json['StudentID'] ?? '',
      classSection: json['ClassSection'] ?? '',
      resultMap: Map<String, Map<String, String>>.from(json['ResultMap'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Gender': gender,
      'BForm_challanId': bFormChallanId,
      'FatherName': fatherName,
      'FatherPhoneNo': fatherPhoneNo,
      'FatherCNIC': fatherCNIC,
      'StudentRollNo': studentRollNo,
      'StudentID': studentID,
      'ClassSection': classSection,
      'ResultMap': resultMap,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Gender': gender,
      'BForm_challanId': bFormChallanId,
      'FatherName': fatherName,
      'FatherPhoneNo': fatherPhoneNo,
      'FatherCNIC': fatherCNIC,
      'StudentRollNo': studentRollNo,
      'StudentID': studentID,
      'ClassSection': classSection,
      'ResultMap': resultMap,
      // Add other fields as needed
    };
  }
}
