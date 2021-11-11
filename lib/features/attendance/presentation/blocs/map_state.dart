part of 'map_bloc.dart';

@immutable
abstract class MapState extends Equatable {
  const MapState();
  @override
  List<Object> get props => [];
}
class MapInitial extends MapState {}

class MapLoading extends MapState {}

// ignore: must_be_immutable
class MapLoaded extends MapState {
  LocationData? position;
  MapLoaded({required this.position});
  @override
  List<Object> get props => [];
}

class MapFailed extends MapState {}
class MapLocationDenied extends MapState {}
