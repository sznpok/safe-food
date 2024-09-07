import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/models/food.dart';
import 'package:save_food/providers/food_provider.dart';
import 'package:save_food/providers/user_provider.dart';
import 'package:save_food/screens/map_screen.dart';
import 'package:save_food/screens/payment_page.dart';
import 'package:save_food/utils/size_config.dart';
import 'package:save_food/widgets/curved_body_widget.dart';
import 'package:save_food/widgets/custom_card.dart';
import 'package:save_food/widgets/general_alert_dialog.dart';
import 'package:save_food/widgets/general_elevated_button.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({
    Key? key,
    required this.food,
    required this.toShowButton,
  }) : super(key: key);

  final Food food;
  final bool toShowButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          food.name,
        ),
      ),
      body: CurvedBodyWidget(
        widget: Column(
          children: [
            CustomCard(
              children: [
                SizedBox(
                  width: SizeConfig.width * 100,
                  height: SizeConfig.height * 15,
                  child: Image.memory(
                    base64Decode(food.image),
                    fit: BoxFit.contain,
                    height: SizeConfig.height * 15,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
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
                    : const SizedBox.shrink(),
                if (toShowButton || food.acceptingUserName != null)
                  SizedBox(
                    height: SizeConfig.height * 2,
                  ),
                if (food.acceptingUserName != null)
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
              ],
            ),
            SizedBox(
              height: SizeConfig.height * 3,
            ),
            Expanded(
              child: MapScreen(
                requireAppBar: false,
                latitude: food.latitude,
                longitude: food.longitude,
                title: "Donor",
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: toShowButton
          ? Container(
              color: const Color(0xffEBEEF2),
              padding: basePadding,
              child: GeneralElevatedButton(
                title: food.price != null ? "Paid Food" : "Take Food",
                onPressed: () async {
                  if (food.price != null) {
                    StripePayment().makePayment(
                        context, food.totalPrice.toString(), food.id!);
                    return;
                  } else {
                    try {
                      GeneralAlertDialog().customLoadingDialog(context);
                      final user =
                          Provider.of<UserProvider>(context, listen: false)
                              .user;
                      await Provider.of<FoodProvider>(context, listen: false)
                          .updateFood(
                        context,
                        acceptingUserId: user.uuid,
                        acceptingUserName: user.name ?? "",
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
              ),
            )
          : null,
    );
  }
}
