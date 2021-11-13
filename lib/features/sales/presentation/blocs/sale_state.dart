part of 'sale_cubit.dart';

@immutable
abstract class SaleState {}

class SaleInitial extends SaleState {}
class SaleLoading extends SaleState {}
class SaleFailure extends SaleState {}
class SaleSuccess extends SaleState {}
