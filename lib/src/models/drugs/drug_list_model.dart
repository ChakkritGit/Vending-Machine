class DrugInventory {
  final String inventoryId;
  final int inventoryPosition;
  final int inventoryQty;

  DrugInventory({
    required this.inventoryId,
    required this.inventoryPosition,
    required this.inventoryQty,
  });

  factory DrugInventory.fromJson(Map<String, dynamic> json) {
    return DrugInventory(
      inventoryId: json['inventoryId'],
      inventoryPosition: json['inventoryPosition'],
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
    List<DrugInventory> inventoryList = inventoryListFromJson?.map((i) => DrugInventory.fromJson(i)).toList() ?? [];

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
