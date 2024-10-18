class DrugInventory {
  final String inventoryId;
  final int? inventoryPosition;
  final int? inventoryQty;
  final int? inventoryMin;
  final int? inventoryMax;

  DrugInventory({
    required this.inventoryId,
    this.inventoryPosition,
    this.inventoryQty,
    this.inventoryMin,
    this.inventoryMax,
  });

  factory DrugInventory.fromJson(Map<String, dynamic> json) {
    return DrugInventory(
      inventoryId: json['inventoryId'],
      inventoryPosition: json['inventoryPosition'] ?? 0,
      inventoryQty: json['inventoryQty'] ?? 0,
      inventoryMin: json['inventoryMin'] ?? 0,
      inventoryMax: json['inventoryMax'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventoryId': inventoryId,
      'inventoryPosition': inventoryPosition,
      'inventoryQty': inventoryQty,
      'inventoryMin': inventoryMin,
      'inventoryMax': inventoryMax,
    };
  }
}

class DrugGroup {
  final String groupId;
  final String drugId;
  final String drugName;
  final String drugImage;
  final int? drugPriority;
  final List<DrugInventory> inventoryList;

  DrugGroup({
    required this.groupId,
    required this.drugId,
    required this.drugName,
    required this.drugImage,
    required this.drugPriority,
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
      drugPriority: json['drugPriority'] ?? 0,
      inventoryList: inventoryList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'drugId': drugId,
      'drugName': drugName,
      'drugImage': drugImage,
      'drugPriority': drugPriority,
      'inventoryList': inventoryList.map((i) => i.toJson()).toList(),
    };
  }
}
