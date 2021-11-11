part of 'map_bloc.dart';

@immutable
abstract class MapEvent extends Equatable{
  const MapEvent();
  @override
  List<Object> get props => [];
}
class MapStarted extends MapEvent{}
