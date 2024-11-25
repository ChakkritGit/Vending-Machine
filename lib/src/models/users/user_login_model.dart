class UserLoginModel {
  final String id;
  final String userId;
  final String displayName;
  final DateTime createdAt;

  UserLoginModel({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.createdAt,
  });

  factory UserLoginModel.fromMap(Map<String, dynamic> map) {
    return UserLoginModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      displayName: map['displayName'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
