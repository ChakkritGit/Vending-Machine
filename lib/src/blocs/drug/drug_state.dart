part of 'drug_bloc.dart';

class DrugState extends Equatable {
  final List<Drugs> drugList;
  final List<DrugGroup> drugInventoryList;

  const DrugState({required this.drugList, required this.drugInventoryList});

  DrugState copywith(
      {List<Drugs>? drugList, List<DrugGroup>? drugInventoryList}) {
    return DrugState(
        drugList: drugList ?? this.drugList,
        drugInventoryList: drugInventoryList ?? this.drugInventoryList);
  }

  @override
  List<Object> get props => [drugList, drugInventoryList];
}
