part of 'inventory_bloc.dart';

class InventoryState extends Equatable {
  final List<Inventories> inventoryList;

  const InventoryState({required this.inventoryList});

  InventoryState copywith({List<Inventories>? inventoryList}) {
    return InventoryState(inventoryList: inventoryList ?? this.inventoryList);
  }

  @override
  List<Object> get props => [inventoryList];
}
