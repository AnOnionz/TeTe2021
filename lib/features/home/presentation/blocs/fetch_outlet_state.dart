part of 'fetch_outlet_cubit.dart';

@immutable
abstract class FetchOutletState {}

class FetchOutletInitial extends FetchOutletState {}
class FetchOutletLoading extends FetchOutletState {}
class FetchOutletSuccess extends FetchOutletState {
  final OutletEntity outlet;

  FetchOutletSuccess({required this.outlet});
}
class FetchOutletFailure extends FetchOutletState {
  final String message;

  FetchOutletFailure({required this.message});
}