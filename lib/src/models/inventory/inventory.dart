class Inventories {
  final String id;
  final int inventoryPosition;
  final int inventoryQty;
  final int inventoryMin;
  final int inventoryMAX;
  final int inventoryStatus;
  final String machineId;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final String machineName;
  final int machineStatus;

  Inventories({
    required this.id,
    required this.inventoryPosition,
    required this.inventoryQty,
    required this.inventoryMin,
    required this.inventoryMAX,
    required this.inventoryStatus,
    required this.machineId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.machineName,
    required this.machineStatus,
  });

  factory Inventories.fromJoinedMap(Map<String, dynamic> map) {
    return Inventories(
      id: map['inventoryId'] as String? ?? '',
      inventoryPosition: map['inventoryPosition'] as int? ?? 0,
      inventoryQty: map['inventoryQty'] as int? ?? 0,
      inventoryMin: map['inventoryMin'] as int? ?? 0,
      inventoryMAX: map['inventoryMAX'] as int? ?? 0,
      inventoryStatus: map['inventoryStatus'] as int? ?? 0,
      machineId: map['machineId'] as String? ?? '',
      comment: map['inventoryComment'] as String? ?? '',
      createdAt: map['inventoryCreatedAt'] as String? ?? '',
      updatedAt: map['inventoryUpdatedAt'] as String? ?? '',
      machineName: map['machineName'] as String? ?? '',
      machineStatus: map['machineStatus'] as int? ?? 0,
    );
  }
}
