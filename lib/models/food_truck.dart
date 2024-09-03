class FoodTruck {
  String? id;
  late String truckNo;
  List<String> listOfFoods = [];
  late double latitude;
  late double longitude;

  FoodTruck({
    this.id,
    required this.truckNo,
    required this.listOfFoods,
    required this.latitude,
    required this.longitude,
  });

  FoodTruck.fromJson(Map obj, this.id) {
    truckNo = obj["truckNo"];
    listOfFoods =
        (obj["listOfFoods"] as List).map((e) => e.toString()).toList();
    latitude = obj["latitude"];
    longitude = obj["longitude"];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["truckNo"] = truckNo;
    map["listOfFoods"] = listOfFoods;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    return map;
  }
}
