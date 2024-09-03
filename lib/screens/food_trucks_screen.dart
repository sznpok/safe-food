import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:save_food/models/food_truck.dart';
import 'package:save_food/providers/food_truck_provider.dart';
import 'package:save_food/providers/user_provider.dart';
import 'package:save_food/screens/food_truck_post_screen.dart';
import 'package:save_food/screens/map_screen.dart';
import 'package:save_food/utils/navigate.dart';
import 'package:save_food/utils/size_config.dart';
import 'package:save_food/widgets/curved_body_widget.dart';
import 'package:save_food/widgets/custom_card.dart';
import 'package:save_food/widgets/general_alert_dialog.dart';
import 'package:save_food/widgets/general_elevated_button.dart';
import 'package:provider/provider.dart';

class FoodTruckScreen extends StatelessWidget {
  const FoodTruckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileData = Provider.of<UserProvider>(context, listen: false).user;
    final stream = Provider.of<FoodTruckProvider>(context, listen: false)
        .fetchFoodTrucks(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Truck"),
      ),
      body: CurvedBodyWidget(
        widget: StreamBuilder<QuerySnapshot>(
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
                        "Food Trucks",
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
                          final food = FoodTruck.fromJson(
                              snapshot.data!.docs[index].data() as Map,
                              snapshot.data!.docs[index].id);
                          return foodTruckCard(context, food);
                        },
                        shrinkWrap: true,
                      )
                    ],
                  ),
                );
              }
              return const Center(
                child: Text("Cant load data"),
              );
            }),
      ),
      floatingActionButton: profileData.isFoodDonor
          ? FloatingActionButton(
              onPressed: () {
                navigate(
                  context,
                  FoodTruckPostScreen(),
                );
              },
              child: const Icon(
                Icons.add,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            )
          : null,
    );
  }

  Widget foodTruckCard(BuildContext context, FoodTruck foodTruck) {
    return InkWell(
      onTap: () {
        // navigate(
        // context,
        // FoodDetailScreen(food: food, toShowButton: toShowButton),
        // );
      },
      child: CustomCard(
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.directions_bus_outlined,
                  color: Colors.black,
                  size: SizeConfig.width * 9,
                ),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(.4),
                radius: SizeConfig.width * 8,
              ),
              SizedBox(
                width: SizeConfig.width * 2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodTruck.truckNo,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: SizeConfig.height,
                  ),
                  Text(
                    "Available Foods:",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.height,
          ),
          Wrap(
            children: foodTruck.listOfFoods
                .map(
                  (e) => Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width * 1.5,
                    ),
                    child: Chip(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width * 4,
                      ),
                      label: Text(
                        e,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(
                                .3,
                              ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(
            height: SizeConfig.height * 2,
          ),
          GeneralElevatedButton(
            title: "Get Directions",
            onPressed: () {
              navigate(
                  context,
                  MapScreen(
                    latitude: foodTruck.latitude,
                    longitude: foodTruck.longitude,
                    title: "Food Truck",
                  ));
            },
          ),
        ],
      ),
    );
  }
}
