import 'package:vending_standalone/src/models/drugs/drug_model.dart';

class Stocks {
  final String id;
  final int position;
  final int qty;
  final int minQty;
  final int maxQty;
  final int status;
  final Drugs? drug;

  Stocks({
    required this.id,
    required this.position,
    required this.qty,
    required this.minQty,
    required this.maxQty,
    required this.status,
    this.drug,
  });

  factory Stocks.fromMap(Map<String, dynamic> map) {
    return Stocks(
      id: map['inventoryId'] ?? '',
      position: map['inventoryPosition'] ?? 0,
      qty: map['inventoryQty'] ?? 0,
      minQty: map['inventoryMin'] ?? 0,
      maxQty: map['inventoryMAX'] ?? 0,
      status: map['inventoryStatus'] ?? 0,
      drug: map['drugId'] != null
          ? Drugs.fromMap(map)
          : null, // Check if there's drug info
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inventoryId': id,
      'inventoryPosition': position,
      'inventoryQty': qty,
      'inventoryMin': minQty,
      'inventoryMAX': maxQty,
      'inventoryStatus': status,
      'drug': drug?.toMap(),
    };
  }
}
