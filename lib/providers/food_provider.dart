import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/models/food.dart';
import 'package:save_food/providers/user_provider.dart';
import 'package:save_food/utils/firebase_helper.dart';
import 'package:provider/provider.dart';

class FoodProvider extends ChangeNotifier {
  // List<Food> foods = [];

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchFoods({
    bool whereValue = true,
  }) async* {
    try {
      yield* FirebaseHelper().getStreamWithWhere(
        collectionId: FoodConstant.foodCollection,
        whereId: FoodConstant.isAvailable,
        whereValue: whereValue,
      );
    } catch (ex) {
      throw ex.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchSearchedFoods({
    required String whereId,
    required String whereValue,
    bool firstWhereValue = true,
  }) async* {
    try {
      yield* FirebaseHelper().getStreamWithMultipleWhere(
        collectionId: FoodConstant.foodCollection,
        whereId: FoodConstant.isAvailable,
        whereValue: firstWhereValue,
        whereIdSecond: whereId,
        whereValueSecond: whereValue,
      );
    } catch (ex) {
      throw ex.toString();
    }
  }

  addFoodPost(BuildContext context, Food food) async {
    try {
      // final uuid = Provider.of<UserProvider>(context, listen: false).user.uuid;

      final map = food.toJson();

      await FirebaseHelper().addData(
        context,
        map: map,
        collectionId: FoodConstant.foodCollection,
      );
    } catch (ex) {
      print(ex.toString());
      throw ex.toString();
    }
  }

  updateFood(
    BuildContext context, {
    String? acceptingUserId,
    String? acceptingUserName,
    double? rating,
    required String foodId,
  }) async {
    try {
      final map = {
        if (acceptingUserId != null) "acceptingUserId": acceptingUserId,
        if (acceptingUserId != null) "acceptingUserName": acceptingUserName,
        if (acceptingUserId != null && acceptingUserName != null)
          "isAvailable": false,
        if (rating != null) "rating": rating,
      };

      await FirebaseHelper().updateData(
        context,
        map: map,
        docId: foodId,
        collectionId: FoodConstant.foodCollection,
      );

      // final room = foods.firstWhere((element) => element.id == foodId);
      // room.acceptingUserId = acceptingUserId;
      // room.isAvailable = false;
      // notifyListeners();
    } catch (ex) {
      throw ex.toString();
    }
  }
}
