// import '/utilities/api_calls.dart';
import 'dart:convert';

import 'package:save_food/constants/constants.dart';

import '/models/direction.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MyDirections {
  final googleMapsDirectionUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final mapDirectionUrl = 'https://api.mapbox.com/directions/v5/mapbox/';
  Future<Directions?> fetchDirection(LatLng user, LatLng center) async {
    final urlForMap =
        '${mapDirectionUrl}walking/${user.longitude},${user.latitude};${center.longitude},${center.latitude}?alternatives=true&geometries=polyline&steps=true&access_token=$mapBoxApiKey';

    final mapResponse = await http.get(
      Uri.parse(urlForMap),
    );
    if (mapResponse.statusCode == 200) {
      return Directions.fromMap(json.decode(mapResponse.body));
    }
    return null;
  }
}
