import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/models/food.dart';
import 'package:save_food/providers/user_provider.dart';
import 'package:save_food/screens/set_address_screen.dart';
import 'package:save_food/utils/file_compressor.dart';
import 'package:save_food/utils/navigate.dart';
import 'package:save_food/utils/show_toast_message.dart';
import 'package:save_food/utils/size_config.dart';
import 'package:save_food/utils/validation_mixin.dart';
import 'package:save_food/widgets/general_text_field.dart';

import '../providers/food_provider.dart';
import '../widgets/curved_body_widget.dart';
import '../widgets/general_alert_dialog.dart';
import '../widgets/general_elevated_button.dart';
import '../widgets/general_text_button.dart';

class FoodPostScreen extends StatefulWidget {
  FoodPostScreen({Key? key}) : super(key: key);

  @override
  State<FoodPostScreen> createState() => _FoodPostScreenState();
}

class _FoodPostScreenState extends State<FoodPostScreen> {
  final imageController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final latLngController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isPaid = false; // Track whether the food is paid or free

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Food"),
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                SizedBox(height: SizeConfig.height * 2),
                _buildImagePicker(context),
                SizedBox(height: SizeConfig.height * 2),
                _buildNameField(),
                SizedBox(height: SizeConfig.height * 2),
                _buildFreePaidToggle(),
                SizedBox(height: SizeConfig.height * 2),
                _buildQuantityField(),
                SizedBox(height: SizeConfig.height * 2),
                if (isPaid) _buildPriceField(),
                _buildDescriptionField(),
                _buildLocationField(),
                _buildChooseImageButton(),
                SizedBox(height: SizeConfig.height * 2),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to display the title
  Widget _buildTitle(BuildContext context) {
    return Text(
      "Fill the information about Food",
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
    );
  }

  // Widget to handle image selection
  Widget _buildImagePicker(BuildContext context) {
    return Center(
      child: SizedBox(
        height: SizeConfig.height * 20,
        width: SizeConfig.width * 100,
        child: imageController.text.isEmpty
            ? Column(
                children: [
                  Icon(
                    Icons.image,
                    size: SizeConfig.height * 12,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    "Upload Image",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              )
            : Image.memory(
                base64Decode(imageController.text),
                fit: BoxFit.contain,
              ),
      ),
    );
  }

  // Food Name TextField
  Widget _buildNameField() {
    return GeneralTextField(
      title: "Food Name",
      controller: nameController,
      textInputType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validate: (v) => ValidationMixin().validate(v!, "Food Name"),
      onFieldSubmitted: (_) {},
    );
  }

  // Toggle Button for Free or Paid Food
  Widget _buildFreePaidToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ToggleButtons(
            fillColor: Colors.green,
            selectedColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            borderWidth: 2.0,
            constraints: BoxConstraints.expand(
              width: SizeConfig.width * 18,
              height: 50,
            ),
            isSelected: [!isPaid, isPaid],
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Free', style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Paid', style: TextStyle(fontSize: 16)),
              ),
            ],
            onPressed: (int index) {
              setState(() {
                isPaid = index == 1;
              });
            },
          ),
        ),
      ],
    );
  }

  // Quantity TextField
  Widget _buildQuantityField() {
    return GeneralTextField(
      title: "Quantity",
      controller: quantityController,
      textInputType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validate: (v) => ValidationMixin().validateNumber(v!, "Quantity", 1000),
      onFieldSubmitted: (_) {},
    );
  }

  // Price TextField (only shown if Paid option is selected)
  Widget _buildPriceField() {
    return Column(
      children: [
        GeneralTextField(
          title: "Unit Price",
          controller: priceController,
          textInputType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validate: (v) =>
              ValidationMixin().validateNumber(v!, "Unit Price", 10000),
          maxLength: 4,
          onFieldSubmitted: (_) {},
        ),
        SizedBox(height: SizeConfig.height * 2),
      ],
    );
  }

  // Food Description TextField
  Widget _buildDescriptionField() {
    return GeneralTextField(
      title: "Food Description",
      controller: descriptionController,
      textInputType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validate: (v) => ValidationMixin().validate(v!, "Food Description"),
      maxLines: 5,
      onFieldSubmitted: (_) {},
    );
  }

  // Latitude and Longitude Field
  Widget _buildLocationField() {
    return GeneralTextField(
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
        final value = await navigate(context, const SetAddressScreen());
        if (value != null) {
          latitudeController.text = value.lat.toString();
          longitudeController.text = value.lng.toString();
          latLngController.text = "${value.lat} N ${value.lng} E";
        }
      },
      textInputAction: TextInputAction.next,
      validate: (v) => ValidationMixin().validate(v!, "Latitude and Longitude"),
      onFieldSubmitted: (_) {},
    );
  }

  // Button to choose an image
  Widget _buildChooseImageButton() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.height * 3),
        GeneralTextButton(
          onPressed: () async {
            await showBottomSheet(context);
            setState(() {});
          },
          title: "Choose Image",
        ),
      ],
    );
  }

  // Submit Button
  Widget _buildSubmitButton() {
    return GeneralElevatedButton(
      title: "Submit",
      onPressed: () async {
        onSubmit(context);
      },
    );
  }

  // Show bottom sheet for image selection
  Future<void> showBottomSheet(BuildContext context) async {
    final imagePicker = ImagePicker();
    await showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: basePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose a source",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: SizeConfig.height * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildChooseOptions(
                  context,
                  func: () async => await _pickImage(
                      context, imagePicker, ImageSource.camera),
                  iconData: Icons.camera_outlined,
                  label: "Camera",
                ),
                buildChooseOptions(
                  context,
                  func: () async => await _pickImage(
                      context, imagePicker, ImageSource.gallery),
                  iconData: Icons.collections_outlined,
                  label: "Gallery",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to pick an image from the specified source
  Future<void> _pickImage(
      BuildContext context, ImagePicker imagePicker, ImageSource source) async {
    final xFile = await imagePicker.pickImage(source: source);
    if (xFile != null) {
      final int sizeInBytes = await xFile.length();
      final double sizeInMb = sizeInBytes / 1000000;
      if (sizeInMb > 1.0) {
        final compressedFile = await compressFile(xFile);
        if (compressedFile != null) {
          imageController.text = base64Encode(compressedFile);
        }
      } else {
        final unit8list = await xFile.readAsBytes();
        imageController.text = base64Encode(unit8list);
      }
      Navigator.pop(context);
    }
  }

  // Widget to display the options for choosing image
  Column buildChooseOptions(BuildContext context,
      {required Function func,
      required IconData iconData,
      required String label}) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            func();
          },
          color: Theme.of(context).primaryColor,
          iconSize: SizeConfig.height * 6,
          icon: Icon(iconData),
        ),
        Text(label),
      ],
    );
  }

  // Function to handle form submission
  onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        if (imageController.text.isEmpty) {
          showToast("Please upload an image");
          return;
        }

        final food = Food(
          name: nameController.text,
          postedUserName:
              Provider.of<UserProvider>(context, listen: false).user.name ??
                  "Unknown",
          image: imageController.text,
          description: descriptionController.text,
          price: isPaid ? double.parse(priceController.text) : null,
          quantity: int.parse(quantityController.text),
          totalPrice: isPaid
              ? double.parse(priceController.text) *
                  int.parse(quantityController.text)
              : 0.0,
          latitude: double.parse(latitudeController.text),
          longitude: double.parse(longitudeController.text),
          postedBy: Provider.of<UserProvider>(context, listen: false).user.uuid,
        );

        GeneralAlertDialog().customLoadingDialog(context);
        await Provider.of<FoodProvider>(context, listen: false)
            .addFoodPost(context, food);
        showToast("Food added successfully");
        Navigator.pop(context); // Close the loading dialog
      } catch (e) {
        showToast("Failed to post food, make sure your connection is active");
      }
    }
  }
}
