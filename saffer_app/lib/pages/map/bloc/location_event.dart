part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

class StartLocationUpdates extends LocationEvent {}

class StopLocationUpdates extends LocationEvent {}

class LocationChanged extends LocationEvent {
  final Position position;
  LocationChanged(this.position);
}