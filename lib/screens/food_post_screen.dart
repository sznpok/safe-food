// // import 'dart:convert';
// // import 'dart:typed_data';

// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:save_food/constants/constants.dart';
// // import 'package:save_food/models/food.dart';
// // import 'package:save_food/providers/food_provider.dart';
// // import 'package:save_food/providers/user_provider.dart';
// // import 'package:save_food/screens/set_address_screen.dart';
// // import 'package:save_food/utils/file_compressor.dart';
// // import 'package:save_food/utils/navigate.dart';
// // import 'package:save_food/utils/show_toast_message.dart';
// // import 'package:save_food/utils/size_config.dart';
// // import 'package:save_food/utils/validation_mixin.dart';
// // import 'package:save_food/widgets/curved_body_widget.dart';
// // import 'package:save_food/widgets/general_alert_dialog.dart';
// // import 'package:save_food/widgets/general_elevated_button.dart';
// // import 'package:save_food/widgets/general_text_button.dart';
// // import 'package:save_food/widgets/general_text_field.dart';
// // import 'package:provider/provider.dart';

// // class FoodPostScreen extends StatefulWidget {
// //   FoodPostScreen({Key? key}) : super(key: key);

// //   @override
// //   State<FoodPostScreen> createState() => _FoodPostScreenState();
// // }

// // class _FoodPostScreenState extends State<FoodPostScreen> {
// //   final imageController = TextEditingController();

// //   final nameController = TextEditingController();

// //   final descriptionController = TextEditingController();

// //   final priceController = TextEditingController();

// //   final quantityController = TextEditingController();

// //   final latitudeController = TextEditingController();

// //   final longitudeController = TextEditingController();

// //   final latLngController = TextEditingController();

// //   final formKey = GlobalKey<FormState>();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Post Food"),
// //       ),
// //       body: CurvedBodyWidget(
// //         widget: SingleChildScrollView(
// //           child: Form(
// //             key: formKey,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   "Fill the information about Food",
// //                   style: Theme.of(context).textTheme.titleSmall!.copyWith(
// //                         fontWeight: FontWeight.w500,
// //                         fontSize: 18,
// //                       ),
// //                 ),
// //                 SizedBox(
// //                   height: SizeConfig.height * 2,
// //                 ),
// //                 Center(
// //                   child: SizedBox(
// //                     height: SizeConfig.height * 20,
// //                     width: SizeConfig.width * 100,
// //                     child: imageController.text.isEmpty
// //                         ? Column(
// //                             children: [
// //                               Icon(
// //                                 Icons.image,
// //                                 size: SizeConfig.height * 12,
// //                                 color: Theme.of(context).primaryColor,
// //                               ),
// //                               Text(
// //                                 "Upload Image",
// //                                 style: Theme.of(context).textTheme.bodyMedium,
// //                               )
// //                             ],
// //                           )
// //                         : Image.memory(
// //                             base64Decode(imageController.text),
// //                             fit: BoxFit.contain,
// //                           ),
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: SizeConfig.height * 2,
// //                 ),
// //                 SizedBox(
// //                   height: SizeConfig.height * 2,
// //                 ),
// //                 GeneralTextField(
// //                   title: "Food Name",
// //                   controller: nameController,
// //                   textInputType: TextInputType.name,
// //                   textInputAction: TextInputAction.next,
// //                   validate: (v) => ValidationMixin().validate(v!, "Food Name"),
// //                   onFieldSubmitted: (_) {},
// //                 ),
// //                 SizedBox(
// //                   height: SizeConfig.height * 2,
// //                 ),
// //                 GeneralTextField(
// //                   title: "Unit Price",
// //                   controller: priceController,
// //                   textInputType: TextInputType.number,
// //                   textInputAction: TextInputAction.next,
// //                   validate: (v) => ValidationMixin().validateNumber(
// //                     v!,
// //                     "Unit Price",
// //                     10000,
// //                   ),
// //                   maxLength: 4,
// //                   onFieldSubmitted: (_) {},
// //                 ),
// //                 SizedBox(
// //                   height: SizeConfig.height * 2,
// //                 ),
// //                 GeneralTextField(
// //                   title: "Quantity",
// //                   controller: quantityController,
// //                   textInputType: TextInputType.number,
// //                   textInputAction: TextInputAction.next,
// //                   validate: (v) => ValidationMixin().validateNumber(
// //                     v!,
// //                     "Quantity",
// //                     1000,
// //                   ),
// //                   onFieldSubmitted: (_) {},
// //                 ),
// //                 SizedBox(
// //                   height: SizeConfig.height * 2,
// //                 ),
// //                 GeneralTextField(
// //                   title: "Food Description",
// //                   controller: descriptionController,
// //                   textInputType: TextInputType.name,
// //                   textInputAction: TextInputAction.next,
// //                   validate: (v) =>
// //                       ValidationMixin().validate(v!, "Food Description"),
// //                   maxLines: 5,
// //                   onFieldSubmitted: (_) {},
// //                 ),
// //                 SizedBox(
// //                   height: SizeConfig.height * 2,
// //                 ),
// //                 GeneralTextField(
// //                   title: "Latitude and Longitude",
// //                   textInputType: TextInputType.none,
// //                   controller: latLngController,
// //                   isReadOnly: true,
// //                   suffixWidget: Icon(
// //                     Icons.arrow_drop_down_outlined,
// //                     size: SizeConfig.height * 3.5,
// //                     color: Theme.of(context).primaryColor,
// //                   ),
// //                   onTap: () async {
// //                     final value =
// //                         await navigate(context, const SetAddressScreen());
// //                     if (value != null) {
// //                       latitudeController.text = value.lat.toString();
// //                       longitudeController.text = value.lng.toString();
// //                       latLngController.text = "${value.lat} N ${value.lng} E";
// //                     }
// //                   },

// //                   textInputAction: TextInputAction.next,

// //                   validate: (v) =>
// //                       ValidationMixin().validate(v!, "Latitude and Longitude"),
// //                   // maxLines: 5,
// //                   onFieldSubmitted: (_) {
// //                     onSubmit(context);
// //                   },
// //                 ),
// //                 SizedBox(
// //                   height: SizeConfig.height * 3,
// //                 ),
// //                 GeneralTextButton(
// //                   onPressed: () async {
// //                     await showBottomSheet(context);
// //                     // Navigator.pop();
// //                     setState(() {});
// //                     // if (map.isNotEmpty) {}
// //                   },
// //                   title: "Choose Image",
// //                 ),
// //                 SizedBox(
// //                   height: SizeConfig.height * 2,
// //                 ),
// //                 GeneralElevatedButton(
// //                   title: "Submit",
// //                   onPressed: () async {
// //                     onSubmit(context);
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> showBottomSheet(BuildContext context) async {
// //     final imagePicker = ImagePicker();

// //     await showModalBottomSheet(
// //       context: context,
// //       builder: (_) => Padding(
// //         padding: basePadding,
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Text(
// //               "Choose a source",
// //               style: Theme.of(context).textTheme.titleSmall,
// //             ),
// //             SizedBox(
// //               height: SizeConfig.height * 2,
// //             ),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// //               children: [
// //                 buildChooseOptions(
// //                   context,
// //                   func: () async {
// //                     final xFile =
// //                         await imagePicker.pickImage(source: ImageSource.camera);
// //                     if (xFile != null) {
// //                       final int sizeInBytes = await xFile.length();
// //                       final double sizeInMb = sizeInBytes / 1000000;
// //                       if (sizeInMb > 1.0) {
// //                         final compressedFile = await compressFile(xFile);
// //                         if (compressedFile != null) {
// //                           imageController.text = base64Encode(compressedFile);
// //                         }
// //                       } else {
// //                         final unit8list = await xFile.readAsBytes();
// //                         imageController.text = base64Encode(unit8list);
// //                       }

// //                       Navigator.pop(context);
// //                     }
// //                   },
// //                   iconData: Icons.camera_outlined,
// //                   label: "Camera",
// //                 ),
// //                 buildChooseOptions(
// //                   context,
// //                   func: () async {
// //                     final xFile = await imagePicker.pickImage(
// //                         source: ImageSource.gallery);
// //                     if (xFile != null) {
// //                       final int sizeInBytes = await xFile.length();
// //                       final double sizeInMb = sizeInBytes / 1000000;
// //                       if (sizeInMb > 1.0) {
// //                         final compressedFile = await compressFile(xFile);
// //                         if (compressedFile != null) {
// //                           imageController.text = base64Encode(compressedFile);
// //                         }
// //                       } else {
// //                         final unit8list = await xFile.readAsBytes();
// //                         imageController.text = base64Encode(unit8list);
// //                       }
// //                       Navigator.pop(context);
// //                     }
// //                   },
// //                   iconData: Icons.collections_outlined,
// //                   label: "Gallery",
// //                 ),
// //               ],
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Column buildChooseOptions(
// //     BuildContext context, {
// //     required Function func,
// //     required IconData iconData,
// //     required String label,
// //   }) {
// //     return Column(
// //       children: [
// //         IconButton(
// //           onPressed: () {
// //             print("object");
// //             func();
// //           },
// //           color: Theme.of(context).primaryColor,
// //           iconSize: SizeConfig.height * 6,
// //           icon: Icon(iconData),
// //         ),
// //         Text(label),
// //       ],
// //     );
// //   }

// //   onSubmit(BuildContext context) async {
// //     if (formKey.currentState!.validate()) {
// //       try {
// //         if (imageController.text.isEmpty) {
// //           showToast("Please upload an image");
// //           return;
// //         }
// //         final food = Food(
// //             name: nameController.text,
// //             image: imageController.text,
// //             description: descriptionController.text,
// //             price: double.parse(priceController.text),
// //             quantity: int.parse(quantityController.text),
// //             totalPrice: double.parse(priceController.text) *
// //                 int.parse(quantityController.text),
// //             postedBy:
// //                 Provider.of<UserProvider>(context, listen: false).user.uuid,
// //             latitude: double.parse(latitudeController.text),
// //             longitude: double.parse(longitudeController.text));
// //         GeneralAlertDialog().customLoadingDialog(context);
// //         await Provider.of<FoodProvider>(context, listen: false)
// //             .addFoodPost(context, food);
// //         Navigator.pop(context);
// //         Navigator.pop(context);
// //       } catch (ex) {
// //         Navigator.pop(context);
// //         GeneralAlertDialog().customAlertDialog(context, ex.toString());
// //       }
// //     }
// //   }
// // }


// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:save_food/constants/constants.dart';
// import 'package:save_food/models/food.dart';
// import 'package:save_food/providers/food_provider.dart';
// import 'package:save_food/providers/user_provider.dart';
// import 'package:save_food/screens/set_address_screen.dart';
// import 'package:save_food/utils/file_compressor.dart';
// import 'package:save_food/utils/navigate.dart';
// import 'package:save_food/utils/show_toast_message.dart';
// import 'package:save_food/utils/size_config.dart';
// import 'package:save_food/utils/validation_mixin.dart';
// import 'package:save_food/widgets/curved_body_widget.dart';
// import 'package:save_food/widgets/general_alert_dialog.dart';
// import 'package:save_food/widgets/general_elevated_button.dart';
// import 'package:save_food/widgets/general_text_button.dart';
// import 'package:save_food/widgets/general_text_field.dart';
// import 'package:provider/provider.dart';

// class FoodPostScreen extends StatefulWidget {
//   FoodPostScreen({Key? key}) : super(key: key);

//   @override
//   State<FoodPostScreen> createState() => _FoodPostScreenState();
// }

// class _FoodPostScreenState extends State<FoodPostScreen> {
//   final imageController = TextEditingController();
//   final nameController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final priceController = TextEditingController();
//   final quantityController = TextEditingController();
//   final latitudeController = TextEditingController();
//   final longitudeController = TextEditingController();
//   final latLngController = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Post Food"),
//       ),
//       body: CurvedBodyWidget(
//         widget: SingleChildScrollView(
//           child: Form(
//             key: formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Fill the information about Food",
//                   style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 18,
//                       ),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.height * 2,
//                 ),
//                 Center(
//                   child: SizedBox(
//                     height: SizeConfig.height * 20,
//                     width: SizeConfig.width * 100,
//                     child: imageController.text.isEmpty
//                         ? Column(
//                             children: [
//                               Icon(
//                                 Icons.image,
//                                 size: SizeConfig.height * 12,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                               Text(
//                                 "Upload Image",
//                                 style: Theme.of(context).textTheme.bodyMedium,
//                               )
//                             ],
//                           )
//                         : Image.memory(
//                             base64Decode(imageController.text),
//                             fit: BoxFit.contain,
//                           ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.height * 2,
//                 ),
//                 GeneralTextField(
//                   title: "Food Name",
//                   controller: nameController,
//                   textInputType: TextInputType.name,
//                   textInputAction: TextInputAction.next,
//                   validate: (v) => ValidationMixin().validate(v!, "Food Name"),
//                   onFieldSubmitted: (_) {},
//                 ),
//                 SizedBox(
//                   height: SizeConfig.height * 2,
//                 ),
//                 GeneralTextField(
//                   title: "Category",
//                   controller: priceController,
//                   textInputType: TextInputType.text,
//                   textInputAction: TextInputAction.next,
//                   validate: (v) => ValidationMixin().validate(
//                     v!,"Category"
                
                    
//                   ),
                  
//                   onFieldSubmitted: (_) {},
//                 ),
//                 SizedBox(
//                   height: SizeConfig.height * 2,
//                 ),
//                 GeneralTextField(
//                   title: "Quantity",
//                   controller: quantityController,
//                   textInputType: TextInputType.number,
//                   textInputAction: TextInputAction.next,
//                   validate: (v) => ValidationMixin().validateNumber(
//                     v!,
//                     "Quantity",
//                     1000,
//                   ),
//                   onFieldSubmitted: (_) {},
//                 ),
//                 SizedBox(
//                   height: SizeConfig.height * 2,
//                 ),
//                 GeneralTextField(
//                   title: "Food Description",
//                   controller: descriptionController,
//                   textInputType: TextInputType.name,
//                   textInputAction: TextInputAction.next,
//                   validate: (v) =>
//                       ValidationMixin().validate(v!, "Food Description"),
//                   maxLines: 5,
//                   onFieldSubmitted: (_) {},
//                 ),
//                 SizedBox(
//                   height: SizeConfig.height * 2,
//                 ),
//                 GeneralTextField(
//                   title: "Latitude and Longitude",
//                   textInputType: TextInputType.none,
//                   controller: latLngController,
//                   isReadOnly: true,
//                   suffixWidget: Icon(
//                     Icons.arrow_drop_down_outlined,
//                     size: SizeConfig.height * 3.5,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   onTap: () async {
//                     final value =
//                         await navigate(context, const SetAddressScreen());
//                     if (value != null) {
//                       latitudeController.text = value.lat.toString();
//                       longitudeController.text = value.lng.toString();
//                       latLngController.text = "${value.lat} N ${value.lng} E";
//                     }
//                   },
//                   textInputAction: TextInputAction.next,
//                   validate: (v) =>
//                       ValidationMixin().validate(v!, "Latitude and Longitude"),
//                   onFieldSubmitted: (_) {
//                     onSubmit(context);
//                   },
//                 ),
//                 SizedBox(
//                   height: SizeConfig.height * 3,
//                 ),
//                 GeneralTextButton(
//                   onPressed: () async {
//                     await showBottomSheet(context);
//                     setState(() {});
//                   },
//                   title: "Choose Image",
//                 ),
//                 SizedBox(
//                   height: SizeConfig.height * 2,
//                 ),
//                 GeneralElevatedButton(
//                   title: "Submit",
//                   onPressed: () async {
//                     onSubmit(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> showBottomSheet(BuildContext context) async {
//     final imagePicker = ImagePicker();

//     await showModalBottomSheet(
//       context: context,
//       builder: (_) => Padding(
//         padding: basePadding,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Choose a source",
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//             SizedBox(
//               height: SizeConfig.height * 2,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 buildChooseOptions(
//                   context,
//                   func: () async {
//                     final xFile =
//                         await imagePicker.pickImage(source: ImageSource.camera);
//                     if (xFile != null) {
//                       handleImageSelection(xFile);
//                       Navigator.pop(context);
//                     }
//                   },
//                   iconData: Icons.camera_outlined,
//                   label: "Camera",
//                 ),
//                 buildChooseOptions(
//                   context,
//                   func: () async {
//                     final xFile = await imagePicker.pickImage(
//                         source: ImageSource.gallery);
//                     if (xFile != null) {
//                       handleImageSelection(xFile);
//                       Navigator.pop(context);
//                     }
//                   },
//                   iconData: Icons.collections_outlined,
//                   label: "Gallery",
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> handleImageSelection(XFile xFile) async {
//     try {
//       final int sizeInBytes = await xFile.length();
//       final double sizeInMb = sizeInBytes / 1000000;

//       if (sizeInMb > 1.0) {
//         final compressedFile = await compressFile(xFile);
//         if (compressedFile != null) {
//           imageController.text = base64Encode(compressedFile);
//         } else {
//           showToast("Failed to compress image");
//         }
//       } else {
//         final unit8list = await xFile.readAsBytes();
//         imageController.text = base64Encode(unit8list);
//       }
//     } catch (e) {
//       showToast("Error processing image: $e");
//     }
//   }

//   Column buildChooseOptions(
//     BuildContext context, {
//     required Function func,
//     required IconData iconData,
//     required String label,
//   }) {
//     return Column(
//       children: [
//         IconButton(
//           onPressed: () {
//             func();
//           },
//           color: Theme.of(context).primaryColor,
//           iconSize: SizeConfig.height * 6,
//           icon: Icon(iconData),
//         ),
//         Text(label),
//       ],
//     );
//   }

//   onSubmit(BuildContext context) async {
//     if (formKey.currentState!.validate()) {
//       try {
//         if (imageController.text.isEmpty) {
//           showToast("Please upload an image");
//           return;
//         }

//         final food = Food(
//           name: nameController.text,
//           image: imageController.text,
//           description: descriptionController.text,
//           price: double.parse(priceController.text),
//           quantity: int.parse(quantityController.text),
//           totalPrice: double.parse(priceController.text) *
//               int.parse(quantityController.text),
//           postedBy:
//               Provider.of<UserProvider>(context, listen: false).user.uuid,
//           latitude: double.parse(latitudeController.text),
//           longitude: double.parse(longitudeController.text),
//         );

//         GeneralAlertDialog().customLoadingDialog(context);

//         await Provider.of<FoodProvider>(context, listen: false)
//             .addFoodPost(context, food);

//         Navigator.pop(context); // Close the loading dialog
//         // Navigator.pop(context); // Close the FoodPostScreen
//       } catch (ex) {
//         Navigator.pop(context); // Close the loading dialog
//         GeneralAlertDialog().customAlertDialog(context, ex.toString());
//       }
//     }
//   }
// }



import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/models/food.dart';
import 'package:save_food/providers/food_provider.dart';
import 'package:save_food/providers/user_provider.dart';
import 'package:save_food/screens/set_address_screen.dart';
import 'package:save_food/utils/file_compressor.dart';
import 'package:save_food/utils/navigate.dart';
import 'package:save_food/utils/show_toast_message.dart';
import 'package:save_food/utils/size_config.dart';
import 'package:save_food/utils/validation_mixin.dart';
import 'package:save_food/widgets/curved_body_widget.dart';
import 'package:save_food/widgets/general_alert_dialog.dart';
import 'package:save_food/widgets/general_elevated_button.dart';
import 'package:save_food/widgets/general_text_button.dart';
import 'package:save_food/widgets/general_text_field.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Food"),
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fill the information about Food",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                Center(
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
                              )
                            ],
                          )
                        : Image.memory(
                            base64Decode(imageController.text),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                GeneralTextField(
                  title: "Food Name",
                  controller: nameController,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validate: (v) => ValidationMixin().validate(v!, "Food Name"),
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                GeneralTextField(
                  title: "Unit Price",
                  controller: priceController,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validate: (v) => ValidationMixin().validateNumber(
                    v!,
                    "Unit Price",
                    10000,
                  ),
                  maxLength: 4,
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                GeneralTextField(
                  title: "Quantity",
                  controller: quantityController,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validate: (v) => ValidationMixin().validateNumber(
                    v!,
                    "Quantity",
                    1000,
                  ),
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                GeneralTextField(
                  title: "Food Description",
                  controller: descriptionController,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validate: (v) =>
                      ValidationMixin().validate(v!, "Food Description"),
                  maxLines: 5,
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
                  height: SizeConfig.height * 3,
                ),
                GeneralTextButton(
                  onPressed: () async {
                    await showBottomSheet(context);
                    // Navigator.pop();
                    setState(() {});
                    // if (map.isNotEmpty) {}
                  },
                  title: "Choose Image",
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
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
      ),
    );
  }

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
            SizedBox(
              height: SizeConfig.height * 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildChooseOptions(
                  context,
                  func: () async {
                    final xFile =
                        await imagePicker.pickImage(source: ImageSource.camera);
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
                  },
                  iconData: Icons.camera_outlined,
                  label: "Camera",
                ),
                buildChooseOptions(
                  context,
                  func: () async {
                    final xFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);
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
                  },
                  iconData: Icons.collections_outlined,
                  label: "Gallery",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column buildChooseOptions(
    BuildContext context, {
    required Function func,
    required IconData iconData,
    required String label,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            print("object");
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

  onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        if (imageController.text.isEmpty) {
          showToast("Please upload an image");
          return;
        }
        final food = Food(
            name: nameController.text,
            image: imageController.text,
            description: descriptionController.text,
            price: double.parse(priceController.text),
            quantity: int.parse(quantityController.text),
            totalPrice: double.parse(priceController.text) *
                int.parse(quantityController.text),
            postedBy:
                Provider.of<UserProvider>(context, listen: false).user.uuid,
            latitude: double.parse(latitudeController.text),
            longitude: double.parse(longitudeController.text));
        GeneralAlertDialog().customLoadingDialog(context);
        await Provider.of<FoodProvider>(context, listen: false)
            .addFoodPost(context, food);
        Navigator.pop(context);
        Navigator.pop(context);
      } catch (ex) {
        Navigator.pop(context);
        GeneralAlertDialog().customAlertDialog(context, ex.toString());
      }
    }
  }
}
