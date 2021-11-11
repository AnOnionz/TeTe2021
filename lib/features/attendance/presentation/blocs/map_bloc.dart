import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:equatable/equatable.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial());
  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is MapStarted) {
        yield MapLoading();
        try {
          Location location = Location();
          bool _serviceEnabled;
          PermissionStatus _permissionGranted;
          _serviceEnabled = await location.serviceEnabled();
          if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
          }
          _permissionGranted = await location.hasPermission();
          if (_permissionGranted == PermissionStatus.denied) {
            _permissionGranted = await location.requestPermission();
          }
          final LocationData? position = await location.getLocation().timeout(const Duration(seconds: 10));
          if (position != null) {
            yield MapLoaded(position: position);
          } else {
            yield MapFailed();
          }
        } on PlatformException catch (error) {
          yield MapLocationDenied();
        }
        catch (e, s) {
          print(e);
          print(s);
          yield MapFailed();
        }
      }

    }
}
