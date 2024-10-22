class CodeUse {
  final String id;
  final String userid;
  final String codeid;
  final DateTime day;

  CodeUse({
    required this.id,
    required this.userid,
    required this.codeid,
    required this.day,
  });

  factory CodeUse.fromJson(Map<String, dynamic> json) {
    return CodeUse(
      id: json['_id'],
      userid: json['userid'],
      codeid: json['codeid'],
      day: DateTime.parse(json['day']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userid,
      'codeid': codeid,
      'day': day.toIso8601String(),
    };
  }

  CodeUse copyWith({
    String? id,
    String? userid,
    String? codeid,
    DateTime? day,
  }) {
    return CodeUse(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      codeid: codeid ?? this.codeid,
      day: day ?? this.day,
    );
  }
}
