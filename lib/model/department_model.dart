class Department {
  final String code;
  final String displayName;

  Department({required this.code, required this.displayName});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      code: json['code'],
      displayName: json['displayName'],
    );
  }
}
