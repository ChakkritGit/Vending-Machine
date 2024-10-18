part of 'inventory_bloc.dart';

class InventoryState extends Equatable {
  final List<Inventories> inventoryList;
  final List<Stocks> stockList;

  const InventoryState({required this.inventoryList, required this.stockList});

  InventoryState copywith(
      {List<Inventories>? inventoryList, List<Stocks>? stockList}) {
    return InventoryState(
        inventoryList: inventoryList ?? this.inventoryList,
        stockList: stockList ?? this.stockList);
  }

  @override
  List<Object> get props => [inventoryList, stockList];
}
