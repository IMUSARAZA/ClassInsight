import 'package:classinsight/models/ClassModel.dart';
import 'package:classinsight/models/SchoolModel.dart';
import 'package:classinsight/models/TeacherModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:get/get.dart';

class Database_Service extends GetxService {
  static Future<void> saveStudent(String school, Student student) async {
    try {
      CollectionReference studentsRef = FirebaseFirestore.instance
          .collection('Schools')
          .doc(school)
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

  static Future<List<Student>> getStudentsOfASpecificClass(
      String school, String classSection) async {
    List<Student> students = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Schools')
          .doc(school)
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

    List<String> classes = querySnapshot.docs.map((doc) => doc['className'] as String).toList();
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
        .where('className', isEqualTo: className)
        .get();

    if (classQuery.docs.isEmpty) {
      return [];
    }

    DocumentSnapshot classDoc = classQuery.docs.first;
    Map<String, dynamic>? classData = classDoc.data() as Map<String, dynamic>?;

    if (classData != null && classData.containsKey('subjects')) {
      List<dynamic> subjectsDynamic = classData['subjects'];
      List<String> subjects = subjectsDynamic.map((subject) => subject.toString()).toList();
      return subjects;
    } else {
      print('No subjects field found in class document');
      return [];
    }
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
      CollectionReference schoolsRef = FirebaseFirestore.instance.collection('Schools');

      QuerySnapshot schoolSnapshot = await schoolsRef.where('SchoolID', isEqualTo: schoolID).get();

      if (schoolSnapshot.docs.isEmpty) {
        print('School with ID $schoolID not found');
        return;
      }

      DocumentReference schoolDocRef = schoolSnapshot.docs.first.reference;

      CollectionReference teacherRef = schoolDocRef.collection('Teachers');

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


static Future<List<Teacher>> fetchTeachers(String schoolID) async {
    try {
      // Access Firestore collection reference for 'Schools'
      CollectionReference schoolsRef = FirebaseFirestore.instance.collection('Schools');

      QuerySnapshot schoolSnapshot = await schoolsRef.where('SchoolID', isEqualTo: schoolID).get();

      if (schoolSnapshot.docs.isEmpty) {
        print('School with ID $schoolID not found');
        return []; 
      }

      DocumentReference schoolDocRef = schoolSnapshot.docs.first.reference;

      CollectionReference teachersRef = schoolDocRef.collection('Teachers');

      QuerySnapshot teachersSnapshot = await teachersRef.get();

      List<Teacher> teachers = teachersSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Teacher(
          empID: data['EmployeeID'],
          name: data['Name'],
          gender: data['Gender'],
          cnic: data['CNIC'],
          fatherName: data['FatherName'],
          classes: List<String>.from(data['Classes'] ?? []),
          subjects: (data['Subjects'] as Map<String, dynamic>).map((key, value) {
            return MapEntry(key, List<String>.from(value));
          }),
          classTeacher: data['ClassTeacher'],
        );
      }).toList();

      return teachers;
    } catch (e) {
      print('Error fetching teachers: $e');
      return [];
    }
  }

  static Future<void> deleteTeacher(String schoolID, String empID) async {
    try {
      CollectionReference schoolsRef =
          FirebaseFirestore.instance.collection('Schools');

      QuerySnapshot schoolSnapshot =
          await schoolsRef.where('SchoolID', isEqualTo: schoolID).get();

      if (schoolSnapshot.docs.isEmpty) {
        print('School with ID $schoolID not found');
        return;
      }

      DocumentReference schoolDocRef = schoolSnapshot.docs.first.reference;

      CollectionReference teachersRef =
          schoolDocRef.collection('Teachers');

      QuerySnapshot teacherSnapshot =
          await teachersRef.where('EmployeeID', isEqualTo: empID).get();

      if (teacherSnapshot.docs.isEmpty) {
        print('Teacher with EmployeeID $empID not found');
        return;
      }

      DocumentSnapshot teacherDoc = teacherSnapshot.docs.first;

      await teacherDoc.reference.delete();

      print('Teacher with EmployeeID $empID deleted successfully');
    } catch (e) {
      print('Error deleting teacher: $e');
    }
  }

  static Future<List<Teacher>> searchTeachers(String schoolID, String searchText) async {
    try {
      CollectionReference schoolsRef =
          FirebaseFirestore.instance.collection('Schools');

      QuerySnapshot schoolSnapshot =
          await schoolsRef.where('SchoolID', isEqualTo: schoolID).get();

      if (schoolSnapshot.docs.isEmpty) {
        print('School with ID $schoolID not found');
        return []; 
      }

      DocumentReference schoolDocRef = schoolSnapshot.docs.first.reference;

      CollectionReference teachersRef =
          schoolDocRef.collection('Teachers');

      QuerySnapshot teachersSnapshot;

      if (searchText.isNotEmpty) {
        teachersSnapshot = await teachersRef.where('Name', isGreaterThanOrEqualTo: searchText.toUpperCase())
                                            .where('Name', isLessThan: searchText.toUpperCase() + 'z')
                                            .get();
      } else {
        teachersSnapshot = await teachersRef.get();
      }

      List<Teacher> teachers = teachersSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Teacher(
          empID: data['EmployeeID'],
          name: data['Name'],
          gender: data['Gender'],
          cnic: data['CNIC'],
          fatherName: data['FatherName'],
          classes: List<String>.from(data['Classes'] ?? []),
          subjects: (data['Subjects'] as Map<String, dynamic>).map((key, value) {
            return MapEntry(key, List<String>.from(value));
          }),
          classTeacher: data['ClassTeacher'],
        );
      }).toList();

      print('Teachers found: ${teachers.length}');

      return teachers;
    } catch (e) {
      print('Error searching teachers: $e');
      return [];
    }
  }


  static Future<List<Student>> searchStudentsByRollNo(
      String school, String classSection, String rollNo) async {
    List<Student> students = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Schools')
          .doc(school)
          .collection('Students')
          .where('ClassSection', isEqualTo: classSection)
          .where('RollNo', isEqualTo: rollNo)
          .get();

      for (var doc in querySnapshot.docs) {
        students.add(Student.fromJson(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print(
          'Error searching students by roll number $rollNo in class $classSection: $e');
    }
    return students;
  }

  static Future<Student?> getStudentByID(
      String school, String studentID) async {
    Student? student;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Schools')
          .doc(school)
          .collection('Students')
          .where('StudentID', isEqualTo: studentID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        student = Student.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        print('Student not found for ID: $studentID');
      }
    } catch (e) {
      print('Error searching students by ID $studentID: $e');
    }
    return student;
  }

  static Future<void> updateStudent(
      String school, String studentID, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('Schools')
          .doc(school)
          .collection('Students')
          .doc(studentID)
          .update(data);
      print('Student updated successfully');
    } catch (e) {
      print('Error updating student: $e');
    }
  }

  static Future<void> deleteStudent(String schoolID, String studentID) async {
    try {
      DocumentReference studentRef = FirebaseFirestore.instance
          .collection('Schools')
          .doc(schoolID)
          .collection('Students')
          .doc(studentID);

      await studentRef.delete();
      print('Student deleted successfully');
    } catch (e) {
      print('Error deleting student: $e');
    }
  }


 static Future<List<School>> getAllSchools() async {
    List<School> schools = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Schools')
          .get();
          
      for (var doc in querySnapshot.docs) {
        schools.add(School.fromJson(doc.data() as Map<String, dynamic>));
        print(doc.data());
      }
    } catch (e) {
      print('Error getting schools: $e');
    }
    return schools;
  }

static Future<void> addClass(List<String>? classes, List<String>? subjects, List<String> examSystem) async {

  String schoolID = 'buwF2J4lkLCdIVrHfgkP';

     try {
      QuerySnapshot schoolSnapshot = await FirebaseFirestore.instance
          .collection('Schools')
          .where('SchoolID', isEqualTo: schoolID)
          .get();

      if (schoolSnapshot.docs.isNotEmpty) {
        DocumentReference schoolDoc = schoolSnapshot.docs.first.reference;
        CollectionReference classesCollection = schoolDoc.collection('Classes');

        for (String className in classes ?? []) {
          String classId = classesCollection.doc().id; 
          
          Class newClass = Class(
            classId: classId,
            className: className,
            subjects: subjects ?? [],
            examTypes: examSystem,
          );

          await classesCollection.doc(classId).set(newClass.toJson());
        }

        print('Classes added successfully');
      } else {
        print('School document not found');
      }
    } catch (e) {
      print('Error adding classes: $e');
    }
  }











}


