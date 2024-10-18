part of 'inventory_bloc.dart';

sealed class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class InventoryList extends InventoryEvent {
  final List<Inventories>? inventoryList;

  const InventoryList({this.inventoryList});

  @override
  List<Object> get props => [inventoryList ?? []];
}

class StockList extends InventoryEvent {
  final List<Stocks>? stockList;

  const StockList({this.stockList});

  @override
  List<Object> get props => [stockList ?? []];
}
