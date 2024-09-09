import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/models/food.dart';
import 'package:save_food/models/user.dart';
import 'package:save_food/providers/food_provider.dart';
import 'package:save_food/screens/food_detail_screen.dart';
import 'package:save_food/screens/update_food_screeen.dart';
import 'package:save_food/utils/show_toast_message.dart';
import 'package:save_food/widgets/general_drop_down.dart';
import 'package:save_food/widgets/general_elevated_button.dart';
import 'package:save_food/widgets/general_text_field.dart';

import '/providers/user_provider.dart';
import '/utils/navigate.dart';
import '/utils/size_config.dart';
import '/widgets/curved_body_widget.dart';
import '../widgets/general_alert_dialog.dart';

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

  // Build AppBar with enhanced design
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Welcome Home!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      // Center the title
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      actions: profileData.isFoodDonor ? null : [_buildSearchButton()],
    );
  }

  // Build Search Button with Icon
  IconButton _buildSearchButton() {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.search_rounded),
      onPressed: () => _showSearchModal(),
    );
  }

  // Show Search Modal
  Future<void> _showSearchModal() async {
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: basePadding.left,
          right: basePadding.right,
          top: basePadding.top,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _buildSearchForm(),
      ),
    );
  }

  // Build Search Form
  Widget _buildSearchForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Enter your search parameters",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: SizeConfig.height * 2),
          GeneralTextField(
            title: "Search",
            controller: searchController,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.search,
            validate: (v) => null,
            onFieldSubmitted: (_) {},
          ),
          SizedBox(height: SizeConfig.height * 3),
          GeneralElevatedButton(
            title: "Submit",
            onPressed: _onSearchSubmit,
          ),
        ],
      ),
    );
  }

  // Handle Search Submit
  void _onSearchSubmit() {
    if (searchController.text.trim().isEmpty) {
      stream = Provider.of<FoodProvider>(context, listen: false).fetchFoods();
    } else {
      stream =
          Provider.of<FoodProvider>(context, listen: false).fetchSearchedFoods(
        whereId: FoodConstant.title,
        whereValue: searchController.text.trim(),
      );
    }
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: CurvedBodyWidget(
        widget: _buildFoodStream(),
      ),
    );
  }

  // StreamBuilder to show food posts
  StreamBuilder<QuerySnapshot> _buildFoodStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data != null) {
          return _buildFoodList(snapshot);
        }
        return const Center(child: Text("Can't load data"));
      },
    );
  }

  // Build Food List
  Widget _buildFoodList(AsyncSnapshot<QuerySnapshot> snapshot) {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterAndSearchRow(),
          SizedBox(height: SizeConfig.height),
          ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(height: SizeConfig.height * 2),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final food = Food.fromJson(
                  snapshot.data!.docs[index].data() as Map,
                  snapshot.data!.docs[index].id);
              bool isOwner = food.postedBy == currentUser.uid;
              return foodCard(context, food, isOwner);
            },
            shrinkWrap: true,
            primary: false,
          )
        ],
      ),
    );
  }

  // Build Filter and Search Row
  Widget _buildFilterAndSearchRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: SizeConfig.width * 55,
            child: Text(
              profileData.isFoodDonor && filterController.text.trim().isNotEmpty
                  ? "${filterController.text} Foods"
                  : searchController.text.trim().isNotEmpty
                      ? "Foods based on ${searchController.text}"
                      : "Foods",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (profileData.isFoodDonor) _buildFilterChip(),
          if (searchController.text.trim().isNotEmpty) _buildClearSearchChip(),
        ],
      ),
    );
  }

  // Build Filter Chip with Icon
  Widget _buildFilterChip() {
    return InkWell(
      onTap: _showFilterModal,
      child: Chip(
        label: const Text("Filter"),
        avatar: const Icon(Icons.sort_outlined, color: Colors.black),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.8),
      ),
    );
  }

  // Show Filter Modal
  Future<void> _showFilterModal() async {
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: basePadding.left,
          right: basePadding.right,
          top: basePadding.top,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _buildFilterForm(),
      ),
    );
  }

  // Build Filter Form
  Widget _buildFilterForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filter Option",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: SizeConfig.height * 2),
          GeneralDropDown(filterController),
          SizedBox(height: SizeConfig.height * 3),
          GeneralElevatedButton(
            title: "Submit",
            onPressed: _onFilterSubmit,
          ),
        ],
      ),
    );
  }

  // Handle Filter Submit
  void _onFilterSubmit() {
    if (filterController.text.trim() == FilterOptionConstant.filterList[0]) {
      stream = Provider.of<FoodProvider>(context, listen: false).fetchFoods();
    } else {
      stream = Provider.of<FoodProvider>(context, listen: false)
          .fetchFoods(whereValue: false);
    }
    Navigator.pop(context);
    setState(() {});
  }

  // Build Clear Search Chip with Icon
  Widget _buildClearSearchChip() {
    return InkWell(
      onTap: _clearSearch,
      child: Chip(
        avatar: const Icon(Icons.clear_outlined, color: Colors.black),
        label: const Text("Clear Search"),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.8),
      ),
    );
  }

  // Clear Search
  void _clearSearch() {
    stream = Provider.of<FoodProvider>(context, listen: false).fetchFoods();
    searchController.clear();
    setState(() {});
  }

  // Food Card Widget
  Widget foodCard(BuildContext context, Food food, bool isOwner) {
    final toShowButton =
        !Provider.of<UserProvider>(context, listen: false).user.isFoodDonor;
    return InkWell(
      onTap: () => navigate(
        context,
        FoodDetailScreen(food: food, toShowButton: toShowButton),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 4,
          vertical: SizeConfig.height * 2, // Adjusted for better spacing
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.width * 4),
          child: _buildFoodCardDetails(context, food, toShowButton, isOwner),
        ),
      ),
    );
  }

  // Build Food Card Details
  Widget _buildFoodCardDetails(
      BuildContext context, Food food, bool toShowButton, bool isOwner) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFoodImageRow(context, food, isOwner),
        SizedBox(height: SizeConfig.height * 2), // Adjusted spacing
        _buildFoodPriceRow(context, food),
        if (toShowButton || food.acceptingUserName != null)
          SizedBox(height: SizeConfig.height * 2),
        if (food.acceptingUserName != null) _buildAcceptedRow(context, food),
        if (toShowButton) _buildActionButton(context, food),
      ],
    );
  }

  // Build Food Image Row
  Widget _buildFoodImageRow(BuildContext context, Food food, bool isOwner) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFoodImage(food),
        SizedBox(width: SizeConfig.width * 3), // Adjusted spacing
        _buildFoodDetailsColumn(context, food, isOwner),
      ],
    );
  }

  // Build Food Image
  Widget _buildFoodImage(Food food) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.memory(
        base64Decode(food.image),
        fit: BoxFit.cover,
        height: SizeConfig.height * 15,
        width: SizeConfig.width * 30,
      ),
    );
  }

  // Build Food Details Column
  Widget _buildFoodDetailsColumn(
      BuildContext context, Food food, bool isOwner) {
    String _selectedOption = 'None';
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                food.name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              const Spacer(),
              isOwner &&
                      Provider.of<UserProvider>(context, listen: false)
                          .user
                          .isFoodDonor
                  ? PopupMenuButton<String>(
                      iconColor: Colors.green,
                      onSelected: (String result) {
                        setState(() {
                          _selectedOption = result;
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          child: IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateFoodPostScreen(
                                    food: food,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        PopupMenuItem<String>(
                          child: IconButton(
                            icon: const Icon(Icons.delete_outlined,
                                color: Colors.red),
                            onPressed: () {
                              Future.delayed(const Duration(seconds: 2), () {
                                GeneralAlertDialog()
                                    .customLoadingDialog(context);
                              });
                              Provider.of<FoodProvider>(context, listen: false)
                                  .deleteFoodItem(context, food.id ?? "");
                              showToast("Deleted successfully");
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(height: SizeConfig.height * 0.5), // Adjusted spacing
          Text(
            food.description,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: SizeConfig.height * 2), // Adjusted spacing
          _buildQuantityAndPriceRow(context, food),
        ],
      ),
    );
  }

  // Build Quantity and Price Row
  Widget _buildQuantityAndPriceRow(BuildContext context, Food food) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailLabel(context, "Quantity"),
            Text(
              food.quantity.toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        _buildUnitPrice(context, food),
      ],
    );
  }

  void _updateFoodData(Food updatedFood) async {
    try {
      await FirebaseFirestore.instance
          .collection('foodCollection')
          .doc(updatedFood.id)
          .update(updatedFood.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update food'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Build Unit Price
  Widget _buildUnitPrice(BuildContext context, Food food) {
    return food.price != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildDetailLabel(context, "Unit Price"),
              Text(
                "AUD. ${food.price}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildDetailLabel(context, "Food"),
              Text(
                "Free",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          );
  }

  // Build Detail Label
  Widget _buildDetailLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.height * 0.5),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
      ),
    );
  }

  // Build Food Price Row
  Widget _buildFoodPriceRow(BuildContext context, Food food) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (food.price != null)
          Text(
            "Total Price: AUD ${food.totalPrice}",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildDetailLabel(context, "Posted By"),
            Text(
              food.postedUserName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  // Build Accepted By Row
  Widget _buildAcceptedRow(BuildContext context, Food food) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Accepted By: ${food.acceptingUserName!}",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (food.rating != null) _buildRatingRow(context, food),
      ],
    );
  }

  // Build Rating Row
  Widget _buildRatingRow(BuildContext context, Food food) {
    return Row(
      children: [
        Text(
          "Rating: ",
          style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }

  // Build Action Button
  Widget _buildActionButton(BuildContext context, Food food) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.height * 2),
      child: Text(
        food.price != null ? "Paid Food" : "Take Food",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: food.price != null ? Colors.black : Colors.green,
              fontWeight:
                  food.price != null ? FontWeight.bold : FontWeight.w500,
            ),
      ),
    );
  }
}
