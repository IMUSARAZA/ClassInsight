class Class{
  final String className,classId;
  final List<String> subjects, examTypes;


  Class({
    required this.className,
    required this.classId,
    required this.subjects,
    required this.examTypes,
  });


  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      classId: json['classId'],
      className: json['className'] ?? '',
      subjects: json['subjects'] ?? '',
      examTypes: json['examtypes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'className': className,
      'subjects': subjects,
      'examTypes': examTypes,
    };
  }
}

