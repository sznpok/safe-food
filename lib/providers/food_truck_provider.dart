import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/models/food.dart';
import 'package:save_food/models/food_truck.dart';
import 'package:save_food/utils/firebase_helper.dart';

class FoodTruckProvider extends ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchFoodTrucks(
      BuildContext context) async* {
    try {
      yield* FirebaseHelper().getStream(
        collectionId: FoodTruckConstant.truckCollection,
      );
    } catch (ex) {
      print(ex.toString());
      throw ex.toString();
    }
  }

  addFoodTruck(BuildContext context, FoodTruck foodTruck) async {
    try {
      // final uuid = Provider.of<UserProvider>(context, listen: false).user.uuid;

      final map = foodTruck.toJson();

      await FirebaseHelper().addData(
        context,
        map: map,
        collectionId: FoodTruckConstant.truckCollection,
      );
    } catch (ex) {
      print(ex.toString());
      throw ex.toString();
    }
  }
}
