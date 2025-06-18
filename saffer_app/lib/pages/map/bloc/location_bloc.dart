import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _locationSubscription;

  LocationBloc() : super(LocationInitial()) {
    on<StartLocationUpdates>(_onStartLocationUpdates);
    on<LocationChanged>(_onLocationChanged);
    on<StopLocationUpdates>(_onStopLocationUpdates);
  }

  Future<void> _onStartLocationUpdates(
    StartLocationUpdates event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationError('Location permission denied.'));
          return;
        }
      }

      if (!await Geolocator.isLocationServiceEnabled()) {
        emit(LocationError('Location services are disabled.'));
        return;
      }

      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 500,
        ),
      ).listen(
        (position) {
          add(LocationChanged(position));
        },
        onError: (error) {
          emit(LocationError('Location error: $error'));
        },
      );
    } catch (e) {
      emit(LocationError('Failed to start location updates: $e'));
    }
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<LocationState> emit,
  ) {
    emit(LocationSuccess(event.position));
  }

  Future<void> _onStopLocationUpdates(
    StopLocationUpdates event,
    Emitter<LocationState> emit,
  ) async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    emit(LocationInitial());
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
