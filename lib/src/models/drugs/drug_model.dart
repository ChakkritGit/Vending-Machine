class Drugs {
  final String id;
  final String drugName;
  final String drugUnit;
  final String drugImage;
  final int? drugPriority;
  final int drugStatus;
  final String comment;
  final String createdAt;
  final String updatedAt;

  Drugs({
    required this.id,
    required this.drugName,
    required this.drugUnit,
    required this.drugImage,
    required this.drugPriority,
    required this.drugStatus,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'drugName': drugName,
      'drugUnit': drugUnit,
      'drugImage': drugImage,
      'drugPriority': drugPriority,
      'drugStatus': drugStatus,
      'comment': comment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Drugs.fromMap(Map<String, dynamic> map) {
    return Drugs(
      id: map['id'] as String? ?? '',
      drugName: map['drugName'] as String? ?? '',
      drugUnit: map['drugUnit'] as String? ?? '',
      drugImage: map['drugImage'] as String? ?? '',
      drugPriority: map['drugPriority'] as int? ?? 0,
      drugStatus: map['drugStatus'] as int? ?? 0,
      comment: map['comment'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
    );
  }
}
