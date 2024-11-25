class Groups {
  final String groupId;
  final String id;
  final String drugId;
  final String inventoryId;
  final int groupStatus;
  final String? comment;
  final String createdAt;
  final String updatedAt;

  final String drugName;
  final String drugUnit;
  final String drugImage;
  final int drugStatus;
  final int inventoryPosition;
  final int inventoryQty;
  final int inventoryMin;
  final int inventoryMax;
  final int inventoryStatus;
  final String machineId;

  Groups({
    required this.groupId,
    required this.id,
    required this.drugId,
    required this.inventoryId,
    required this.groupStatus,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.drugName,
    required this.drugUnit,
    required this.drugImage,
    required this.drugStatus,
    required this.inventoryPosition,
    required this.inventoryQty,
    required this.inventoryMin,
    required this.inventoryMax,
    required this.inventoryStatus,
    required this.machineId,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'id': id,
      'drugId': drugId,
      'inventoryId': inventoryId,
      'groupStatus': groupStatus,
      'comment': comment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'drugName': drugName,
      'drugUnit': drugUnit,
      'drugImage': drugImage,
      'drugStatus': drugStatus,
      'inventoryPosition': inventoryPosition,
      'inventoryQty': inventoryQty,
      'inventoryMin': inventoryMin,
      'inventoryMax': inventoryMax,
      'inventoryStatus': inventoryStatus,
      'machineId': machineId,
    };
  }

  factory Groups.fromMap(Map<String, dynamic> map) {
    return Groups(
      groupId: map['groupId'] as String? ?? '',
      id: map['id'] as String? ?? '',
      drugId: map['drugId'] as String? ?? '',
      inventoryId: map['inventoryId'] as String? ?? '',
      groupStatus: map['groupStatus'] as int? ?? 0,
      comment: map['comment'] as String?,
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
      drugName: map['drugName'] as String? ?? '',
      drugUnit: map['drugUnit'] as String? ?? '',
      drugImage: map['drugImage'] as String? ?? '',
      drugStatus: map['drugStatus'] as int? ?? 0,
      inventoryPosition: map['inventoryPosition'] as int? ?? 0,
      inventoryQty: map['inventoryQty'] as int? ?? 0,
      inventoryMin: map['inventoryMin'] as int? ?? 0,
      inventoryMax: map['inventoryMax'] as int? ?? 0,
      inventoryStatus: map['inventoryStatus'] as int? ?? 0,
      machineId: map['machineId'] as String? ?? '',
    );
  }
}
