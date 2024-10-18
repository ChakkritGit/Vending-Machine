part of 'drug_bloc.dart';

sealed class DrugEvent extends Equatable {
  const DrugEvent();

  @override
  List<Object> get props => [];
}

class DrugList extends DrugEvent {
  final List<Drugs>? drugList;

  const DrugList({this.drugList});

  @override
  List<Object> get props => [drugList ?? []];
}

class DrugInventoryList extends DrugEvent {
  final List<DrugGroup>? drugInventoryList;

  const DrugInventoryList({this.drugInventoryList});

  @override
  List<Object> get props => [drugInventoryList ?? []];
}
