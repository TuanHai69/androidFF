class Coded {
  final String id;
  final String userid;
  final String code;
  final double percent;
  final DateTime start;
  final DateTime end;
  final String state;

  Coded({
    required this.id,
    required this.userid,
    required this.code,
    required this.percent,
    required this.start,
    required this.end,
    required this.state,
  });

  factory Coded.fromJson(Map<String, dynamic> json) {
    return Coded(
      id: json['_id'],
      userid: json['userid'],
      code: json['code'],
      percent: json['percent'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userid,
      'code': code,
      'percent': percent,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'state': state,
    };
  }

  Coded copyWith({
    String? id,
    String? userid,
    String? code,
    double? percent,
    DateTime? start,
    DateTime? end,
    String? state,
  }) {
    return Coded(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      code: code ?? this.code,
      percent: percent ?? this.percent,
      start: start ?? this.start,
      end: end ?? this.end,
      state: state ?? this.state,
    );
  }
}
