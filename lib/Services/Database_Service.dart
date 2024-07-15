import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classinsight/Model/StudentModel.dart';

// ignore: camel_case_types
class Database_Service {
  
  static Future<void> saveStudent(String schoolId, Student student) async {
  try {
    QuerySnapshot schoolQuery = await FirebaseFirestore.instance
        .collection('Schools')
        .where('SchoolID', isEqualTo: schoolId)
        .get();

    if (schoolQuery.docs.isEmpty) {
      return;
    }

    String schoolDocId = schoolQuery.docs.first.id;

    CollectionReference studentsRef = FirebaseFirestore.instance
        .collection('Schools')
        .doc(schoolDocId)
        .collection('Students');

    DocumentReference docRef = studentsRef.doc();

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
      'ClassSection': student.classSection,
    });

  } catch (e) {
    print('Error saving student: $e');
  }
}


  static Future<List<Student>> getAllStudents(String schoolId) async {
  List<Student> students = [];
  try {
    QuerySnapshot schoolQuery = await FirebaseFirestore.instance
        .collection('Schools')
        .where('SchoolID', isEqualTo: schoolId)
        .get();

    if (schoolQuery.docs.isEmpty) {
      return students;
    }

    String schoolDocId = schoolQuery.docs.first.id;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Schools')
        .doc(schoolDocId)
        .collection('Students')
        .get();

    for (var doc in querySnapshot.docs) {
      students.add(Student.fromJson(doc.data() as Map<String, dynamic>));
    }

  } catch (e) {
    print('Error getting students: $e');
  }
  return students;
}


  static Future<List<Student>> getStudentsOfASpecificClass(String schoolId, String classSection) async {
  List<Student> students = [];
  try {
    QuerySnapshot schoolQuery = await FirebaseFirestore.instance
        .collection('Schools')
        .where('SchoolID', isEqualTo: schoolId)
        .get();

    if (schoolQuery.docs.isEmpty) {
      return students;
    }

    String schoolDocId = schoolQuery.docs.first.id;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Schools')
        .doc(schoolDocId)
        .collection('Students')
        .where('ClassSection', isEqualTo: classSection)
        .get();

    for (var doc in querySnapshot.docs) {
      students.add(Student.fromJson(doc.data() as Map<String, dynamic>));
    }

  } catch (e) {
    print('Error getting students: $e');
  }
  return students;
}


  static Future<List<String>> fetchClasses(String schoolId) async {
  try {
    QuerySnapshot schoolQuery = await FirebaseFirestore.instance
        .collection('Schools')
        .where('SchoolID', isEqualTo: schoolId)
        .get();

    if (schoolQuery.docs.isEmpty) {
      return [];
    }

    String schoolDocId = schoolQuery.docs.first.id;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Schools')
        .doc(schoolDocId)
        .collection('Classes')
        .get();

    List<String> classes = querySnapshot.docs.map((doc) => doc['ClassName'] as String).toList();
    return classes;
  } catch (e) {
    print('Error fetching classes: $e');
    return [];
  }
}


  static Future<List<String>> fetchSubjects(String schoolId, String className) async {
  try {

    QuerySnapshot schoolQuery = await FirebaseFirestore.instance
        .collection('Schools')
        .where('SchoolID', isEqualTo: schoolId)
        .get();

    if (schoolQuery.docs.isEmpty) {
      return [];
    }

    String schoolDocId = schoolQuery.docs.first.id;

    QuerySnapshot classQuery = await FirebaseFirestore.instance
        .collection('Schools')
        .doc(schoolDocId)
        .collection('Classes')
        .where('ClassName', isEqualTo: className)
        .get();

    if (classQuery.docs.isEmpty) {
      return [];
    }

    String classDocId = classQuery.docs.first.id;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Schools')
        .doc(schoolDocId)
        .collection('Classes')
        .doc(classDocId)
        .collection('Subjects')
        .get();


    if (querySnapshot.docs.isEmpty) {
      return [];
    } 

    List<String> subjects = querySnapshot.docs.map((doc) => doc['SubjectName'] as String).toList();
    return subjects;
  } catch (e) {
    print('Error fetching subjects: $e');
    return [];
  }
}

static Future<void> saveTeacher(
    String schoolID,
    String empID,
    String name,
    String gender,
    String phoneNo,
    String cnic,
    String fatherName,
    List<String> classes,
    Map<String, List<String>> subjects,
    String classTeacher,
  ) async {
    try {
      // Reference to the Schools collection
      CollectionReference schoolsRef = FirebaseFirestore.instance.collection('Schools');

      // Query to find the specific school document by SchoolID
      QuerySnapshot schoolSnapshot = await schoolsRef.where('SchoolID', isEqualTo: schoolID).get();

      if (schoolSnapshot.docs.isEmpty) {
        print('School with ID $schoolID not found');
        return;
      }

      // Reference to the specific school document
      DocumentReference schoolDocRef = schoolSnapshot.docs.first.reference;

      // Reference to the Teachers collection under the specific school document
      CollectionReference teacherRef = schoolDocRef.collection('Teachers');

      // Add a new document with auto-generated ID
      await teacherRef.add({
        'EmployeeID': empID,
        'Name': name,
        'Gender': gender,
        'PhoneNo': phoneNo,
        'CNIC': cnic,
        'FatherName': fatherName,
        'Classes': classes,
        'Subjects': subjects,
        'ClassTeacher': classTeacher,
      });

      print('Teacher saved successfully');
    } catch (e) {
      print('Error saving teacher: $e');
    }
  }



}
