import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classinsight/Model/StudentModel.dart';

class Database_Service {
  static Future<void> saveStudent(Student student) async {
    try {
      // Generate a new document reference
      DocumentReference docRef = FirebaseFirestore.instance.collection('Students').doc();
      student.studentID = docRef.id;

      await docRef.set({
        'Name': student.name,
        'Gender': student.gender,
        'BForm_challanId': student.bForm_challanId,
        'FatherName': student.fatherName,
        'FatherPhoneNo': student.fatherPhoneNo,
        'FatherCNIC': student.fatherCNIC,
        'StudentRollNo': student.studentRollNo,
        'StudentID': student.studentID,
      });
    } catch (e) {
      print('Error saving student: $e');
    }
  }
}
