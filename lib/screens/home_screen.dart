import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/models/food.dart';
import 'package:save_food/models/user.dart';
import 'package:save_food/providers/food_provider.dart';
import 'package:save_food/screens/food_detail_screen.dart';
import 'package:save_food/widgets/general_drop_down.dart';
import 'package:save_food/widgets/general_elevated_button.dart';
import 'package:save_food/widgets/general_text_field.dart';

import '/providers/user_provider.dart';
import '/utils/navigate.dart';
import '/utils/size_config.dart';
import '/widgets/curved_body_widget.dart';
import '/widgets/general_alert_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel profileData;
  late Stream<QuerySnapshot> stream;

  final searchController = TextEditingController();
  final filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    profileData = Provider.of<UserProvider>(context, listen: false).user;
    stream = Provider.of<FoodProvider>(context, listen: false).fetchFoods();
  }

  @override
  Widget build(BuildContext context) {
    print("Profile data ${profileData.uuid}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Home!"),
        actions: profileData.isFoodDonor
            ? null
            : [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          left: basePadding.left,
                          right: basePadding.right,
                          top: basePadding.top,
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Enter your search parameters"),
                              SizedBox(
                                height: SizeConfig.height * 2,
                              ),
                              GeneralTextField(
                                title: "Search",
                                controller: searchController,
                                textInputType: TextInputType.text,
                                textInputAction: TextInputAction.search,
                                validate: (v) {
                                  return null;
                                },
                                onFieldSubmitted: (_) {},
                              ),
                              SizedBox(
                                height: SizeConfig.height * 3,
                              ),
                              GeneralElevatedButton(
                                title: "Submit",
                                onPressed: () {
                                  if (searchController.text.trim().isEmpty) {
                                    stream = Provider.of<FoodProvider>(context,
                                            listen: false)
                                        .fetchFoods();
                                  } else {
                                    stream = Provider.of<FoodProvider>(context,
                                            listen: false)
                                        .fetchSearchedFoods(
                                      whereId: FoodConstant.title,
                                      whereValue: searchController.text.trim(),
                                    );
                                  }
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: SizeConfig.width * 55,
                          child: Text(
                            profileData.isFoodDonor &&
                                    filterController.text.trim().isNotEmpty
                                ? "${filterController.text} Foods"
                                : searchController.text.trim().isNotEmpty
                                    ? "Foods based on ${searchController.text}"
                                    : "Foods",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        if (profileData.isFoodDonor)
                          InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.only(
                                    left: basePadding.left,
                                    right: basePadding.right,
                                    top: basePadding.top,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Filter Option"),
                                        SizedBox(
                                          height: SizeConfig.height * 2,
                                        ),
                                        SizedBox(
                                          child: GeneralDropDown(
                                            filterController,
                                          ),
                                        ),
                                        SizedBox(
                                          height: SizeConfig.height * 3,
                                        ),
                                        GeneralElevatedButton(
                                          title: "Submit",
                                          onPressed: () {
                                            if (filterController.text.trim() ==
                                                FilterOptionConstant
                                                    .filterList[0]) {
                                              stream =
                                                  Provider.of<FoodProvider>(
                                                          context,
                                                          listen: false)
                                                      .fetchFoods();
                                            } else {
                                              stream =
                                                  Provider.of<FoodProvider>(
                                                          context,
                                                          listen: false)
                                                      .fetchFoods(
                                                whereValue: false,
                                              );
                                            }
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Chip(
                              label: const Text("Filter"),
                              avatar: const Icon(
                                Icons.sort_outlined,
                                color: Colors.black,
                              ),
                              backgroundColor:
                                  Theme.of(context).primaryColor.withOpacity(
                                        .8,
                                      ),
                            ),
                          ),
                        if (searchController.text.trim().isNotEmpty)
                          InkWell(
                            onTap: () {
                              stream = Provider.of<FoodProvider>(context,
                                      listen: false)
                                  .fetchFoods();
                              searchController.clear();
                              setState(() {});
                            },
                            child: Chip(
                              avatar: const Icon(
                                Icons.clear_outlined,
                                color: Colors.black,
                              ),
                              label: const Text(
                                "Clear Search",
                              ),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.8),
                            ),
                          ),
                      ],
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
                        return foodCard(context, food);
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
      // floatingActionButton: profileData.isFoodDonor
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           navigate(
      //             context,
      //             FoodPostScreen(),
      //           );
      //         },
      //         child: const Icon(
      //           Icons.add,
      //         ),
      //         backgroundColor: Theme.of(context).primaryColor,
      //       )
      //     : null,
    );
  }

  // Widget foodCard(BuildContext context, Food food) {
  //   final toShowButton =
  //       !Provider.of<UserProvider>(context, listen: false).user.isFoodDonor;
  //   return InkWell(
  //     onTap: () => navigate(
  //       context,
  //       FoodDetailScreen(food: food, toShowButton: toShowButton),
  //     ),
  //     child: CustomCard(
  //       children: [
  //         SizedBox(
  //           width: SizeConfig.width * 100,
  //           height: SizeConfig.height * 15,
  //           child: Image.memory(
  //             base64Decode(food.image),
  //             fit: BoxFit.contain,
  //             height: SizeConfig.height * 15,
  //           ),
  //         ),
  //         SizedBox(
  //           height: SizeConfig.height * 2,
  //         ),
  //         Text(
  //           food.name,
  //           style: Theme.of(context).textTheme.titleSmall,
  //         ),
  //         SizedBox(
  //           height: SizeConfig.height * .5,
  //         ),
  //         Text(
  //           food.description,
  //           style: Theme.of(context).textTheme.bodySmall,
  //         ),
  //         SizedBox(
  //           height: SizeConfig.height * 2,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Available Quantity",
  //                   style: Theme.of(context).textTheme.labelLarge,
  //                 ),
  //                 SizedBox(
  //                   height: SizeConfig.height * .5,
  //                 ),
  //                 Text(
  //                   food.quantity.toString(),
  //                   style: Theme.of(context).textTheme.bodyMedium,
  //                 ),
  //               ],
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   "Unit Price",
  //                   style: Theme.of(context).textTheme.labelLarge,
  //                 ),
  //                 SizedBox(
  //                   height: SizeConfig.height * .5,
  //                 ),
  //                 Text(
  //                   "Rs. ${food.price}",
  //                   style: Theme.of(context).textTheme.bodyMedium,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: SizeConfig.height * 2,
  //         ),
  //         Text(
  //           "Total Price: ${food.totalPrice}",
  //           style: Theme.of(context).textTheme.titleSmall!.copyWith(
  //                 fontSize: 16,
  //                 color: Colors.deepOrange,
  //               ),
  //         ),
  //         if (toShowButton || food.acceptingUserName != null)
  //           SizedBox(
  //             height: SizeConfig.height * 2,
  //           ),
  //         if (food.acceptingUserName != null)
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "Accepted By: ${food.acceptingUserName!}",
  //                 style: Theme.of(context).textTheme.bodyMedium,
  //               ),
  //               const Spacer(),
  //               if (food.rating != null)
  //                 Text(
  //                   "Rating: ",
  //                   style: Theme.of(context).textTheme.bodySmall,
  //                 ),
  //               if (food.rating != null)
  //                 RatingBarIndicator(
  //                   rating: food.rating!,
  //                   itemBuilder: (context, index) => const Icon(
  //                     Icons.star,
  //                     color: Colors.orange,
  //                   ),
  //                   itemCount: 5,
  //                   itemSize: SizeConfig.width * 4,
  //                   direction: Axis.horizontal,
  //                 ),
  //             ],
  //           ),
  //         if (toShowButton)
  //           GeneralElevatedButton(
  //             title: "Take Food",
  //             onPressed: () async {
  //               try {
  //                 GeneralAlertDialog().customLoadingDialog(context);
  //                 final user =
  //                     Provider.of<UserProvider>(context, listen: false).user;
  //                 await Provider.of<FoodProvider>(context, listen: false)
  //                     .updateFood(
  //                   context,
  //                   acceptingUserId: user.uuid,
  //                   acceptingUserName: user.name ?? "",
  //                   foodId: food.id!,
  //                 );
  //                 Navigator.pop(context);
  //               } catch (ex) {
  //                 Navigator.pop(context);
  //                 GeneralAlertDialog()
  //                     .customAlertDialog(context, ex.toString());
  //               }
  //             },
  //           )
  //       ],
  //     ),
  //   );
  // }

  Widget foodCard(BuildContext context, Food food) {
    final toShowButton =
        !Provider.of<UserProvider>(context, listen: false).user.isFoodDonor;
    print("Food Card ${food.postedBy}");

    return InkWell(
      onTap: () => navigate(
        context,
        FoodDetailScreen(food: food, toShowButton: toShowButton),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 3,
          vertical: SizeConfig.height * 1,
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.width * 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.memory(
                      base64Decode(food.image),
                      fit: BoxFit.cover,
                      height: SizeConfig.height * 15,
                      width: SizeConfig.width * 30,
                    ),
                  ),
                  SizedBox(width: SizeConfig.width * 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: SizeConfig.height * 1),
                        Text(
                          food.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: SizeConfig.height * 2),
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
                                SizedBox(height: SizeConfig.height * 0.5),
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
                                  "Unit Price",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                SizedBox(height: SizeConfig.height * 0.5),
                                Text(
                                  "Rs. ${food.price}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height * 2),
              Text(
                "Total Price: ${food.totalPrice}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 16,
                      color: Colors.deepOrange,
                    ),
              ),
              if (toShowButton || food.acceptingUserName != null)
                SizedBox(height: SizeConfig.height * 2),
              if (food.acceptingUserName != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Accepted By: ${food.acceptingUserName!}",
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (food.rating != null)
                      Row(
                        children: [
                          Text(
                            "Rating: ",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
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
              if (toShowButton)
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.height * 2),
                  child: GeneralElevatedButton(
                    title: "Take Food",
                    onPressed: () async {
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
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
