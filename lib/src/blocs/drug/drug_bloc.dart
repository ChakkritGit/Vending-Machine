// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vending_standalone/src/models/drugs/drug_list_model.dart';
import 'package:vending_standalone/src/models/drugs/drug_model.dart';
part 'drug_state.dart';
part 'drug_event.dart';

class DrugBloc extends Bloc<DrugEvent, DrugState> {
  DrugBloc() : super(const DrugState(drugList: [], drugInventoryList: [])) {
    on<DrugList>((event, emit) {
      emit(state.copywith(drugList: event.drugList));
    });
    on<DrugInventoryList>((event, emit) {
      emit(state.copywith(drugInventoryList: event.drugInventoryList));
    });
  }
}
