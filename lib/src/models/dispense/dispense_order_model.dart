import 'package:vending_standalone/src/models/drugs/drug_list_model.dart';

class Dispense {
  final int qty;
  final DrugGroup drug;

  Dispense({required this.qty, required this.drug});

  Map<String, dynamic> toMap() {
    return {
      'qty': qty,
      'drug': drug,
    };
  }

  factory Dispense.fromMap(Map<String, dynamic> map) {
    return Dispense(
      qty: map['qty'] as int,
      drug: map['drug'] as DrugGroup,
    );
  }
}