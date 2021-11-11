part of 'sampling_inventory_cubit.dart';

@immutable
abstract class SamplingInventoryState {}

class SamplingInventoryInitial extends SamplingInventoryState {}
class SamplingInventoryLoading extends SamplingInventoryState {}
class SamplingInventoryFailure extends SamplingInventoryState {}
class SamplingInventorySuccess extends SamplingInventoryState {}
