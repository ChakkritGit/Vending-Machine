// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vending/src/models/inventory/inventory.dart';
part 'inventory_state.dart';
part 'inventory_event.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(const InventoryState(inventoryList: [])) {
    on<InventoryList>((event, emit) {
      emit(state.copywith(inventoryList: event.inventoryList));
    });
  }
}
