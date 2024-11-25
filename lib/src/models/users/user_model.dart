class Users {
  final String id;
  final String userName;
  final String userPassword;
  final int userStatus;
  final String userRole;
  final String? displayName;
  final String? userImage;
  final int question;
  final String answer;
  final String? comment;
  final String? createBy;
  final String createdAt;
  final String updatedAt;

  Users({
    required this.id,
    required this.userName,
    required this.userPassword,
    required this.userStatus,
    required this.userRole,
    this.displayName,
    this.userImage,
    required this.question,
    required this.answer,
    this.comment,
    this.createBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'userPassword': userPassword,
      'userStatus': userStatus,
      'userRole': userRole,
      'displayName': displayName,
      'userImage': userImage,
      'question': question,
      'answer': answer,
      'comment': comment,
      'createBy': createBy,
      'createAt': createdAt,
      'updateAt': updatedAt,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      userPassword: map['userPassword'] as String? ?? '',
      userStatus: map['userStatus'] as int? ?? 0,
      userRole: map['userRole'] as String? ?? '',
      displayName: map['displayName'] as String?,
      userImage: map['userImage'] as String?,
      question: map['question'] as int? ?? 0,
      answer: map['answer'] as String? ?? '',
      comment: map['comment'] as String?,
      createBy: map['createBy'] as String?,
      createdAt: map['createAt'].toString(),
      updatedAt: map['updateAt'].toString(),
    );
  }
}
