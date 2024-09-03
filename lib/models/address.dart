class LocationData {
  String address = "";
  double lat = 0.0;
  double lng = 0.0;

  LocationData();

  @override
  String toString() {
    // TODO: implement toString
    return "$lat $lng";
  }
}
