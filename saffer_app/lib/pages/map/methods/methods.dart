import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import "package:http/http.dart" as http;

Future<List<LatLng>> getRoutePolyline({
  required LatLng origin,
  required LatLng destination,
  required String apiKey,
}) async {
  final url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final points = data['routes'][0]['overview_polyline']['points'];
    return decodePolyline(points);
  } else {
    throw Exception('Failed to load directions');
  }
}

List<LatLng> decodePolyline(String encoded) {
  List<LatLng> polyline = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;

    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
    lng += dlng;

    polyline.add(LatLng(lat / 1e5, lng / 1e5));
  }

  return polyline;
}
