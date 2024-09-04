import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/models/food.dart';
import 'package:save_food/providers/food_provider.dart';
import 'package:save_food/providers/user_provider.dart';
import 'package:save_food/utils/size_config.dart';
import 'package:save_food/widgets/curved_body_widget.dart';
import 'package:save_food/widgets/custom_card.dart';
import 'package:save_food/widgets/general_alert_dialog.dart';
import 'package:save_food/widgets/general_elevated_button.dart';

class AcceptedFoodScreen extends StatelessWidget {
  AcceptedFoodScreen({Key? key}) : super(key: key);

  final ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    Stream<QuerySnapshot> stream;
    if (user.isFoodDonor) {
      stream =
          Provider.of<FoodProvider>(context, listen: false).fetchSearchedFoods(
        firstWhereValue: false,
        whereId: FoodConstant.postedBy,
        whereValue: user.uuid,
      );
    } else {
      stream = Provider.of<FoodProvider>(context, listen: false).fetchFoods(
        whereValue: false,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accepted Food"),
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return const Center(
                    child: Text("No Food posts"),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Accepted Foods",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: SizeConfig.height,
                      ),
                      ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: SizeConfig.height * 2,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final food = Food.fromJson(
                              snapshot.data!.docs[index].data() as Map,
                              snapshot.data!.docs[index].id);
                          return foodCard(context, food, user.isFoodDonor);
                        },
                        shrinkWrap: true,
                        primary: false,
                      )
                    ],
                  ),
                );
              }
              return const Center(
                child: Text("Cant load data"),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget foodCard(BuildContext context, Food food, bool isFoodDonor) {
    return CustomCard(
      children: [
        Text(
          food.name,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(
          height: SizeConfig.height * .5,
        ),
        Text(
          food.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(
          height: SizeConfig.height * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Quantity",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(
                  height: SizeConfig.height * .5,
                ),
                Text(
                  food.quantity.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  food.price != null ? "Unit Price" : "Food",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(
                  height: SizeConfig.height * .5,
                ),
                Text(
                  food.price != null ? "Rs. ${food.price}" : "Free",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.height * 2,
        ),
        food.price != null
            ? Text(
                "Total Price: ${food.totalPrice}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 16,
                      color: Colors.deepOrange,
                    ),
              )
            : SizedBox.shrink(),
        SizedBox(
          height: SizeConfig.height,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: SizeConfig.width * 40,
              child: Text(
                "Accepted By: ${food.acceptingUserName!}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Spacer(),
            if (food.rating != null)
              Text(
                "Rating: ",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (food.rating != null)
              RatingBarIndicator(
                rating: food.rating!,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                itemCount: 5,
                itemSize: SizeConfig.width * 4,
                direction: Axis.horizontal,
              ),
          ],
        ),
        if (food.rating == null && !isFoodDonor)
          SizedBox(
            height: SizeConfig.height * 3,
          ),
        if (food.rating == null && !isFoodDonor)
          GeneralElevatedButton(
            title: "Rate",
            onPressed: () async {
              ratingController.clear();
              await showModalBottomSheet(
                context: context,
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    ratingController.clear();
                    return Future.value(true);
                  },
                  child: Padding(
                    padding: basePadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rate the food",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: SizeConfig.height * 2,
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            glowColor: Colors.orangeAccent,
                            glowRadius: SizeConfig.width,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) {
                              return const Icon(
                                Icons.star,
                                color: Colors.orange,
                              );
                            },
                            onRatingUpdate: (rating) {
                              ratingController.text = rating.toStringAsFixed(1);
                            },
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height * 3,
                        ),
                        GeneralElevatedButton(
                          title: "Rate",
                          onPressed: () {
                            if (ratingController.text.isEmpty) {
                              ratingController.text = 3.toString();
                            }
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
              if (ratingController.text.trim().isNotEmpty) {
                try {
                  GeneralAlertDialog().customLoadingDialog(context);
                  final user =
                      Provider.of<UserProvider>(context, listen: false).user;
                  await Provider.of<FoodProvider>(context, listen: false)
                      .updateFood(
                    context,
                    rating: double.parse(ratingController.text),
                    foodId: food.id!,
                  );
                  Navigator.pop(context);
                } catch (ex) {
                  Navigator.pop(context);
                  GeneralAlertDialog()
                      .customAlertDialog(context, ex.toString());
                }
              }
            },
          )
      ],
    );
  }
}
