part of 'sampling_use_cubit.dart';

@immutable
abstract class SamplingUseState {}

class SamplingUseInitial extends SamplingUseState {}
class SamplingUseLoading extends SamplingUseState {}
class SamplingUseSuccess extends SamplingUseState {}
class SamplingUseFailure extends SamplingUseState {}
