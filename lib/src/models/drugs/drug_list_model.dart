class DrugInventory {
  final String inventoryId;
  final int? inventoryPosition;
  int? inventoryQty;

  DrugInventory({
    required this.inventoryId,
    this.inventoryPosition,
    this.inventoryQty,
  });

  factory DrugInventory.fromJson(Map<String, dynamic> json) {
    return DrugInventory(
      inventoryId: json['inventoryId'],
      inventoryPosition: json['inventoryPosition'] ?? 0,
      inventoryQty: json['inventoryQty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventoryId': inventoryId,
      'inventoryPosition': inventoryPosition,
      'inventoryQty': inventoryQty,
    };
  }
}

class DrugGroup {
  final String groupId;
  final String drugId;
  final String drugName;
  final String drugImage;
  final String drugUnit;
  final int? drugPriority;
  final int? groupMin;
  final int? groupMax;
  final List<DrugInventory> inventoryList;

  DrugGroup({
    required this.groupId,
    required this.drugId,
    required this.drugName,
    required this.drugImage,
    required this.drugUnit,
    required this.drugPriority,
    required this.groupMin,
    required this.groupMax,
    required this.inventoryList,
  });

  factory DrugGroup.fromJson(Map<String, dynamic> json) {
    var inventoryListFromJson = json['inventoryList'] as List?;
    List<DrugInventory> inventoryList =
        inventoryListFromJson?.map((i) => DrugInventory.fromJson(i)).toList() ??
            [];

    return DrugGroup(
      groupId: json['groupId'] ?? '',
      drugId: json['drugId'] ?? '',
      drugName: json['drugName'] ?? '',
      drugImage: json['drugImage'] ?? '',
      drugUnit: json['drugUnit'] ?? '',
      drugPriority: json['drugPriority'] ?? 0,
      groupMin: json['groupMin'] ?? 0,
      groupMax: json['groupMax'] ?? 0,
      inventoryList: inventoryList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'drugId': drugId,
      'drugName': drugName,
      'drugImage': drugImage,
      'drugUnit': drugUnit,
      'drugPriority': drugPriority,
      'groupMin': groupMin,
      'groupMax': groupMax,
      'inventoryList': inventoryList.map((i) => i.toJson()).toList(),
    };
  }
}
