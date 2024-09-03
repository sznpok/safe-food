import 'package:flutter/material.dart';
import 'package:save_food/models/food.dart';
import 'package:save_food/models/food_truck.dart';
import 'package:save_food/providers/food_provider.dart';
import 'package:save_food/providers/food_truck_provider.dart';
import 'package:save_food/screens/set_address_screen.dart';
import 'package:save_food/utils/navigate.dart';
import 'package:save_food/utils/size_config.dart';
import 'package:save_food/utils/validation_mixin.dart';
import 'package:save_food/widgets/curved_body_widget.dart';
import 'package:save_food/widgets/general_alert_dialog.dart';
import 'package:save_food/widgets/general_elevated_button.dart';
import 'package:save_food/widgets/general_text_field.dart';
import 'package:provider/provider.dart';

class FoodTruckPostScreen extends StatelessWidget {
  FoodTruckPostScreen({Key? key}) : super(key: key);

  final truckNoController = TextEditingController();
  final foodsController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final latLngController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Food Truck"),
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fill the information about Food Truck",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
              ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
              GeneralTextField(
                title: "Truck No.",
                controller: truckNoController,
                textInputType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                validate: (v) => ValidationMixin().validate(v!, "Food Name"),
                onFieldSubmitted: (_) {},
              ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
              GeneralTextField(
                title: "Latitude and Longitude",
                textInputType: TextInputType.none,
                controller: latLngController,
                isReadOnly: true,
                suffixWidget: Icon(
                  Icons.arrow_drop_down_outlined,
                  size: SizeConfig.height * 3.5,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () async {
                  final value =
                      await navigate(context, const SetAddressScreen());
                  if (value != null) {
                    latitudeController.text = value.lat.toString();
                    longitudeController.text = value.lng.toString();
                    latLngController.text = "${value.lat} N ${value.lng} E";
                  }
                },

                textInputAction: TextInputAction.next,

                validate: (v) =>
                    ValidationMixin().validate(v!, "Latitude and Longitude"),
                // maxLines: 5,
                onFieldSubmitted: (_) {
                  onSubmit(context);
                },
              ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
              GeneralTextField(
                title: "Foods",
                controller: foodsController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validate: (v) => ValidationMixin().validateNumber(
                  v!,
                  "Quantity",
                  1000,
                ),
                onFieldSubmitted: (_) {},
              ),
              SizedBox(
                height: SizeConfig.height,
              ),
              const Text("Note: Type the food names separated with comma,"),
              SizedBox(
                height: SizeConfig.height / 2,
              ),
              const Text("e.g. Momo, Chowmin, Thuppa"),
              SizedBox(
                height: SizeConfig.height * 3,
              ),
              GeneralElevatedButton(
                title: "Submit",
                onPressed: () async {
                  onSubmit(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSubmit(BuildContext context) async {
    try {
      final foodTruck = FoodTruck(
          truckNo: truckNoController.text,
          listOfFoods:
              foodsController.text.split(",").map((e) => e.trim()).toList(),
          latitude: double.parse(latitudeController.text),
          longitude: double.parse(longitudeController.text));
      GeneralAlertDialog().customLoadingDialog(context);
      await Provider.of<FoodTruckProvider>(context, listen: false)
          .addFoodTruck(context, foodTruck);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (ex) {
      Navigator.pop(context);
      GeneralAlertDialog().customAlertDialog(context, ex.toString());
    }
  }
}
