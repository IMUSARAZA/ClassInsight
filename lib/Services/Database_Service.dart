import 'package:classinsight/models/AnnouncementsModel.dart';
import 'package:classinsight/models/ClassModel.dart';
import 'package:classinsight/models/SchoolModel.dart';
import 'package:classinsight/models/TeacherModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classinsight/models/StudentModel.dart';
import 'package:get/get.dart';

class Database_Service extends GetxService {
  Future<void> saveStudent(
      String schoolID, String classSection, Student student) async {
    try {
      // Reference to the Students collection
      CollectionReference studentsRef = FirebaseFirestore.instance
          .collection('Schools')
          .doc(schoolID)
          .collection('Students');

      DocumentReference studentDoc = await studentsRef.add(student.toMap());
      student.studentID = studentDoc.id;
      await studentDoc.update({
        'StudentID': student.studentID,
      }); // Update studentID in Firestore document

      // Fetch subjects for the selected class
      List<String> subjects = await fetchSubjects(schoolID, classSection);

      // Fetch exam types for the selected class
      List<String> examTypes = await fetchExamStructure(schoolID, classSection);

      // Initialize resultMap with subjects and exam types
      Map<String, Map<String, dynamic>> resultMap = {};
      for (String subject in subjects) {
        resultMap[subject] = {};
        for (String examType in examTypes) {
          resultMap[subject]![examType] = '-';
        }
      }

      // Update the student document with resultMap
      await studentDoc.update({'resultMap': resultMap});

      print('Student saved successfully with ID: ${student.studentID}');
    } catch (e) {
      print('Error saving student: $e');
      // Handle errors appropriately, e.g., show error message
    }
  }


  Future<Map<String, Map<String, String>>> fetchStudentResultMap(
      String schoolID, String studentID) async {
    try {
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('Schools')
          .doc(schoolID)
          .collection('Students')
          .doc(studentID)
          .get();

      if (studentDoc.exists) {
        Map<String, dynamic> resultMap = studentDoc['resultMap'];
        return resultMap.map(
            (key, value) => MapEntry(key, Map<String, String>.from(value)));
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching resultMap: $e');
      return {};
    }
  }

  Future<List<String>> fetchExamStructure(
      String schoolID, String className) async {
    try {
      // Reference to the class collection
      QuerySnapshot classQuery = await FirebaseFirestore.instance
          .collection('Schools')
          .doc(schoolID)
          .collection('Classes')
          .where('className', isEqualTo: className)
          .get();

      if (classQuery.size > 0) {
        // Assuming className is unique or you're interested in the first match
        DocumentSnapshot classDoc = classQuery.docs.first;

        // Safely access and cast examType field
        List<dynamic>? examTypes = classDoc.get('examTypes');

        if (examTypes != null) {
          // Convert dynamic list to List<String>
          List<String> examTypesList = examTypes.cast<String>();
          return examTypesList;
        } else {
          print(
              'Exam types not found or invalid format for class $className in school $schoolID.');
          return [];
        }
      } else {
        // No document found for the given className
        print('Class document not found for $className in school $schoolID.');
        return [];
      }
    } catch (e) {
      print('Error fetching exam types: $e');
      return [];
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

      List<String> classes =
          querySnapshot.docs.map((doc) => doc['className'] as String).toList();
      return classes;
    } catch (e) {
      print('Error fetching classes: $e');
      return [];
    }
  }

  static Future<List<String>> fetchSubjects(
      String schoolId, String className) async {
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
      Map<String, dynamic>? classData =
          classDoc.data() as Map<String, dynamic>?;

      if (classData != null && classData.containsKey('subjects')) {
        List<dynamic> subjectsDynamic = classData['subjects'];
        List<String> subjects =
            subjectsDynamic.map((subject) => subject.toString()).toList();
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
      CollectionReference schoolsRef =
          FirebaseFirestore.instance.collection('Schools');

      QuerySnapshot schoolSnapshot =
          await schoolsRef.where('SchoolID', isEqualTo: schoolID).get();

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
      CollectionReference schoolsRef =
          FirebaseFirestore.instance.collection('Schools');

      QuerySnapshot schoolSnapshot =
          await schoolsRef.where('SchoolID', isEqualTo: schoolID).get();

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
          phoneNo: data['PhoneNo'],
          fatherName: data['FatherName'],
          classes: List<String>.from(data['Classes'] ?? []),
          subjects:
              (data['Subjects'] as Map<String, dynamic>).map((key, value) {
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

      CollectionReference teachersRef = schoolDocRef.collection('Teachers');

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
    CollectionReference schoolsRef = FirebaseFirestore.instance.collection('Schools');

    QuerySnapshot schoolSnapshot = await schoolsRef.where('SchoolID', isEqualTo: schoolID).get();

    if (schoolSnapshot.docs.isEmpty) {
      print('School with ID $schoolID not found');
      return [];
    }

    DocumentReference schoolDocRef = schoolSnapshot.docs.first.reference;
    CollectionReference teachersRef = schoolDocRef.collection('Teachers');

    QuerySnapshot teachersSnapshot;

    if (searchText.isNotEmpty) {
      teachersSnapshot = await teachersRef
          .where('Name', isGreaterThanOrEqualTo: searchText)
          .where('Name', isLessThanOrEqualTo: searchText + '\uf8ff')
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
        phoneNo: data['PhoneNo'],
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



static Future<void> deleteClassByName(String schoolName,String className) async {
  try {
    QuerySnapshot schoolQuery = await FirebaseFirestore.instance
        .collection('Schools')
        .where('SchoolName', isEqualTo: schoolName)
        .get();

    if (schoolQuery.docs.isEmpty) {
      print('School not found with name: $schoolName');
      return;
    }

    String schoolId = schoolQuery.docs.first.id;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Schools') 
        .doc(schoolId)
        .collection('Classes') 
        .where('className', isEqualTo: className) 
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    print('Successfully deleted class documents with className: $className');
  } catch (e) {
    print("Error deleting class: $e");
  }
  }




  static Future<String> fetchCounts(String schoolName, String collectionName) async {
    try {
      CollectionReference schoolsRef =
          FirebaseFirestore.instance.collection('Schools');

      QuerySnapshot schoolSnapshot =
          await schoolsRef.where('SchoolName', isEqualTo: schoolName).get();

      if (schoolSnapshot.docs.isEmpty) {
        print('School with ID $schoolName not found');
        return "-";
      }
      DocumentReference schoolDocRef = schoolSnapshot.docs.first.reference;

      CollectionReference teachersRef = schoolDocRef.collection(collectionName);

      QuerySnapshot teachersSnapshot = await teachersRef.get();

      return teachersSnapshot.size.toString();
    } catch (e) {
      print('Error fetching teacher count: $e');
      return "-";
    }
  }



   static Future<void> updateTeacher(
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

      CollectionReference teachersRef = schoolDocRef.collection('Teachers');

      QuerySnapshot teacherSnapshot = await teachersRef.where('EmployeeID', isEqualTo: empID).get();

      if (teacherSnapshot.docs.isEmpty) {
        print('Teacher with EmployeeID $empID not found');
        return;
      }

      DocumentReference teacherDocRef = teacherSnapshot.docs.first.reference;

      await teacherDocRef.update({
        'Name': name,
        'Gender': gender,
        'PhoneNo': phoneNo,
        'CNIC': cnic,
        'FatherName': fatherName,
        'Classes': classes,
        'Subjects': subjects,
        'ClassTeacher': classTeacher,
      });

      print('Teacher updated successfully');
    } catch (e) {
      print('Error updating teacher: $e');
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
        .where('StudentRollNo', isEqualTo: rollNo)
        .get();


    for (var doc in querySnapshot.docs) {
      students.add(Student.fromJson(doc.data() as Map<String, dynamic>));
    }
  } catch (e) {

  }
  return students;
}


  static Future<List<Student>> searchStudentsByName(
      String school, String classSection, String studentName) async {
    List<Student> students = [];
    try {

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Schools')
          .doc(school)
          .collection('Students')
          .where('ClassSection', isEqualTo: classSection)
          .where('Name', isGreaterThanOrEqualTo: studentName)
          .where('Name', isLessThanOrEqualTo: studentName + '\uf8ff')
          .get();

      for (var doc in querySnapshot.docs) {
        students.add(Student.fromJson(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print(
          'Error searching students by name $studentName in class $classSection: $e');
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
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Schools').get();

      for (var doc in querySnapshot.docs) {
        schools.add(School.fromJson(doc.data() as Map<String, dynamic>));
        print(doc.data());
      }
    } catch (e) {
      print('Error getting schools: $e');
    }
    return schools;
  }

  static Future<void> addClass(List<String>? classes, List<String>? subjects,
      List<String> examSystem) async {
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
            timetable: false,
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

  static Future<List<String>> fetchAllClasses(String schoolID) async {
    List<String> classNames = [];
    try {
      CollectionReference classesRef = FirebaseFirestore.instance
          .collection('Schools')
          .doc(schoolID)
          .collection('Classes');
      QuerySnapshot querySnapshot = await classesRef.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        classNames.add(doc[
            'className']); 
      }

      // Sort the class names lexicographically
      classNames.sort();
    } catch (e) {
      print('Error fetching classes: $e');
    }
    return classNames;
  }
 
 
  static Future<List<String>> fetchAllClassesbyTimetable(String schoolID, bool timetable) async {
    List<String> classNames = [];
    try {
      CollectionReference classesRef = FirebaseFirestore.instance
          .collection('Schools')
          .doc(schoolID)
          .collection('Classes');
          
      QuerySnapshot querySnapshot = await classesRef.where("timetable",isEqualTo: timetable).get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        classNames.add(doc[
            'className']); 
      }

      // Sort the class names lexicographically
      classNames.sort();
    } catch (e) {
      print('Error fetching classes: $e');
    }
    return classNames;
  }


  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addTimetablebyClass(String schoolId,String className,String format,Map<String, Map<String, String>> timetable) async {
    try {
      CollectionReference timetableCollection = _firestore.collection('Schools').doc(schoolId).collection('Timetable');
      CollectionReference classesCollection = _firestore.collection('Schools').doc(schoolId).collection('Classes');

      QuerySnapshot querySnapshot = await classesCollection.where('className', isEqualTo: className).get();


      // Save the timetable data
      await timetableCollection.doc(className).set({
        'className': className,
        'format': format,
        'timetable': timetable,
      });

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference classDocRef = querySnapshot.docs.first.reference;
        await classDocRef.update({
          'timetable': true,
        });}
    
      print('Timetable added successfully!');
      Get.snackbar("Added Successfully", "Timetable added successfully for class $className");
    } catch (e) {
      print('Error adding timetable: $e');
      throw e;
    }
  }


  static Future<void> deleteTimetableByClass(String schoolId,String className) async {
    try {
      DocumentReference timetableRef = await _firestore.collection("Schools").doc(schoolId).collection("Timetable").doc(className);
      CollectionReference classesCollection = _firestore.collection('Schools').doc(schoolId).collection('Classes');

      
      DocumentSnapshot timetableSnapshot = await timetableRef.get();
      QuerySnapshot querySnapshot = await classesCollection.where('className', isEqualTo: className).get();



      if (!timetableSnapshot.exists) {
        print("No timetable found for class: $className");
        return;
      }
      await timetableSnapshot.reference.delete();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference classDocRef = querySnapshot.docs.first.reference;
        await classDocRef.update({
          'timetable': false,
        });}

      Get.snackbar("Deleted Succesfully", "Timetable for ${className} has been deleted");
    } catch (e) {
      
    }
  }


  static Future<Map<String, dynamic>> fetchTimetable(String schoolId, String className, String day) async {
    try {
      print("Fetching timetable for schoolId: $schoolId, className: $className");
      
      DocumentReference timetableDocRef = _firestore.collection("Schools").doc(schoolId).collection('Timetable').doc(className);
      DocumentSnapshot timetableSnapshot = await timetableDocRef.get();

      if (!timetableSnapshot.exists) {
        print("No timetable found for class: $className");
        return {};
      }

      Map<String, dynamic>? timetableData = timetableSnapshot.data() as Map<String, dynamic>?;

      if (timetableData == null) {
        print("No data retrieved from the timetable document");
        return {};
      }

      if (!timetableData.containsKey('timetable')) {
        print("No 'timetable' field in the document");
        return {};
      }

      Map<String, dynamic> timetable = timetableData['timetable'] as Map<String, dynamic>;
      Map<String,dynamic> timetablebyDay = timetable[day];
      print(timetablebyDay);
      return timetablebyDay;
    } catch (e) {
      print("Error fetching timetable: $e");
      return {};
    }
  }

  static Future<void> createAnnouncement(
    String schoolID,
    String studentID,
    String announcementDescription,
    String announcementBy,
    bool adminAnnouncement,
  ) async {
    try {
      CollectionReference schoolsRef = FirebaseFirestore.instance.collection('Schools');

      QuerySnapshot schoolSnapshot = await schoolsRef.where('SchoolID', isEqualTo: schoolID).get();

      if (schoolSnapshot.docs.isEmpty) {
        print('School with ID $schoolID not found');
        return;
      }

      DocumentReference schoolDocRef = schoolSnapshot.docs.first.reference;
      CollectionReference announcementsRef = schoolDocRef.collection('Announcements');

      Announcement newAnnouncement = Announcement(
        announcementBy: announcementBy,
        announcementDate: Timestamp.now(),
        announcementDescription: announcementDescription,
        studentID: studentID,
        adminAnnouncement: adminAnnouncement,
      );

      await announcementsRef.add(newAnnouncement.toJson());

      print('Announcement saved successfully');
    } catch (e) {
      print('Error saving announcement: $e');
    }
  }
}