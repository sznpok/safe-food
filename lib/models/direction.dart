import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Directions {
  // LatLngBounds bounds;
  late List<PointLatLng> polylinePoints;
  String totalDistance = '';
  String totalDuration = '';

  Directions({
    // this.bounds,
    required this.polylinePoints,
    // this.totalDistance,
    // this.totalDuration,
  });

  Directions.fromMap(Map<String, dynamic> obj) {
    if ((obj['routes'] as List).isEmpty) return;
    // final data = Map<String, dynamic>.from();
    final dataRoute = obj['routes'];

    // final northEast = data['bounds']['northeast'];
    // final southWest = data['bounds']['southwest'];
    // this.bounds = LatLngBounds(
    //   northeast: LatLng(northEast['lat'], northEast['lng']),
    //   southwest: LatLng(southWest['lat'], southWest['lng']),
    // );

    String distance = '';
    String duration = '';
    if ((dataRoute as List).isNotEmpty) {
      final leg = dataRoute[0];
      distance = leg['distance'].toString();
      duration = leg['duration'].toString();
    }
    final legs = dataRoute[0]['legs'];
    final steps = legs[0]['steps'];
    List<PointLatLng> _dummy = [];

    for (var eachStep in steps) {
      var lat = eachStep['intersections'][0]['location'][1];
      var lng = eachStep['intersections'][0]['location'][0];
      _dummy.add(PointLatLng(lat, lng));
    }
    polylinePoints = _dummy;

    totalDistance = distance;
    totalDuration = duration;
  }
}
