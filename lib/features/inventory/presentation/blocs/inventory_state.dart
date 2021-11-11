part of 'inventory_cubit.dart';

@immutable
abstract class InventoryState {}

class InventoryInitial extends InventoryState {}
class InventoryLoading extends InventoryState {}
class InventorySuccess extends InventoryState {}
class InventoryFailure extends InventoryState {}
