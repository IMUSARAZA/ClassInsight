class Timetable {
  final String className;
  final String format;
  final Map<String, Map<String, String>> timetable;

  Timetable({
    required this.className,
    required this.format,
    required this.timetable,
  });

  // Convert a Timetable object to a map to save in Firestore
  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'format': format,
      'timetable': timetable,
    };
  }

  // Create a Timetable object from a map retrieved from Firestore
  factory Timetable.fromMap(Map<String, dynamic> map) {
    return Timetable(
      className: map['className'],
      format: map['format'],
      timetable: (map['timetable'] as Map<String, dynamic>).map((key, value) => MapEntry(key, Map<String, String>.from(value))),
    );
  }
}
