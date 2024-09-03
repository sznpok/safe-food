class UserModel {
  late String uuid;
  late String? name;
  late String? email;
  late String? image;
  String? tempImage;
  late String? photoUrl;
  late String? address;
  late bool isFoodDonor;
  late String? panNumber;
  late String phoneNumber;

  UserModel({
    required this.uuid,
    required this.name,
    required this.email,
    required this.address,
    required this.image,
    required this.photoUrl,
    this.isFoodDonor = false,
    this.panNumber,
    required this.phoneNumber,
  });

  UserModel.fromJson(Map obj) {
    uuid = obj["uuid"];
    name = obj["name"];
    email = obj["email"];
    image = obj["image"];
    photoUrl = obj["photoUrl"];
    address = obj["address"];
    phoneNumber = obj["phoneNumber"];
    isFoodDonor = obj["isFoodDonor"] ?? false;
    panNumber = obj["panNumber"];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["uuid"] = uuid;
    map["name"] = name;
    map["email"] = email;
    map["image"] = image;
    map["address"] = address;
    map["isFoodDonor"] = isFoodDonor;
    map["phoneNumber"] = phoneNumber;
    map["panNumber"] = panNumber;

    return map;
  }
}
