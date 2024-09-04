class Food {
  String? id;
  late String name;
  late String description;
  late String image;
  late dynamic price;
  late dynamic quantity;
  late double totalPrice;
  late double latitude;
  late double longitude;
  late bool isAvailable;
  late String postedBy;
  late String postedUserName;
  String? acceptingUserId;
  String? acceptingUserName;
  double? rating;

  Food({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.latitude,
    required this.longitude,
    required this.postedUserName,
    required this.postedBy,
    this.isAvailable = true,
  });

  Food.fromJson(Map obj, this.id) {
    name = obj["name"];
    description = obj["description"];
    image = obj["image"] ?? "";
    price = obj["price"];
    quantity = obj["quantity"];
    totalPrice = obj['price'] != null ? obj["price"] * obj["quantity"] : 0;
    latitude = obj["latitude"];
    longitude = obj["longitude"];
    isAvailable = obj["isAvailable"];
    postedBy = obj["postedBy"];
    acceptingUserId = obj["acceptingUserId"];
    acceptingUserName = obj["acceptingUserName"];
    rating = obj["rating"];
    postedUserName = obj["postedUserName"];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["name"] = name;
    map["description"] = description;
    map["image"] = image;
    map["price"] = price;
    map["quantity"] = quantity;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["isAvailable"] = isAvailable;
    map["postedBy"] = postedBy;
    map["acceptingUserId"] = acceptingUserId;
    map["acceptingUserName"] = acceptingUserName;
    map["postedUserName"] = postedUserName;
    return map;
  }
}
