import 'package:flutter/material.dart';
import '/utils/size_config.dart';

const basePadding = EdgeInsets.symmetric(
  vertical: 24,
  horizontal: 16,
);

class ImageConstants {
  static const _basePath = "assets/images";
  static const logo = "$_basePath/logo.png";
  static const logoWithName = "$_basePath/logo.png";
  static const pdfDownload = "$_basePath/pdf_download.png";

  static const notificationIcon = "notification";
}

class UserConstants {
  static const userCollection = "user";
  static const userId = "uuid";
}

class UtilitiesPriceConstant {
  static const utilityPriceCollection = "utilities-price";
  static const userId = "uuid";
}

class FoodConstant {
  static const foodCollection = "food";
  static const isAvailable = "isAvailable";
  static const title = "name";
  static const userId = "uuid";
  static const postedBy = "postedBy";
}

class FoodTruckConstant {
  static const truckCollection = "foodTruck";
}

class RoomRentConstant {
  static const roomRentCollection = "room-rent";
  static const roomId = "roomId";
}

class FilterOptionConstant {
  static const filterList = [
    "Available",
    "Completed",
  ];
}

class SecureStorageConstants {
  static const emailKey = "email";
  static const passwordKey = "password";
}

const googleMapsApiKey = 'AIzaSyBnO7ZyQkatbJR7qBqHKVkiihOjRdzCHiY';

const mapBoxApiKey =
    'pk.eyJ1IjoiaWNoaW5vc2ViaW5pdCIsImEiOiJja25pNXJ2YjYzYm1zMm9waDMxdWIxYW1mIn0.5ur93SBLZGFHNXlvT6vomA';
